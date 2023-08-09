use async_trait::async_trait;
use lg_webos_client::{
    client::{
        SendLgCommandRequest, SendPointerCommandRequest, WebOsClient, WebOsClientConfig,
        WebSocketError,
    },
    discovery::WebOsNetworkInfo,
    lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
};
use serde_json::{json, Value};
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::{json_in_file, web_os_network_info_ffi};

pub enum ClientStateWebOs<Client: SendLgCommandRequest + SendPointerCommandRequest> {
    Disconnected,
    Connected(Arc<Mutex<Client>>),
}

#[async_trait]
pub trait ClientState: SendLgCommandRequest + SendPointerCommandRequest + Send {
    async fn connect(&mut self, config: WebOsClientConfig) -> Result<String, WebSocketError>;
    async fn disconnect(&mut self);
}

#[async_trait]
impl<Client> SendLgCommandRequest for ClientStateWebOs<Client>
where
    Client: SendLgCommandRequest + SendPointerCommandRequest + Send,
{
    async fn send_lg_command_to_tv<R: LGCommandRequest>(
        &mut self,
        cmd: R,
    ) -> Result<Value, WebSocketError> {
        match self {
            ClientStateWebOs::Disconnected => Err(WebSocketError::Fatal),
            ClientStateWebOs::Connected(ref c) => {
                let mut c = c.lock().await;

                c.send_lg_command_to_tv(cmd).await
            }
        }
    }
}

#[async_trait]
impl<Client> SendPointerCommandRequest for ClientStateWebOs<Client>
where
    Client: SendLgCommandRequest + SendPointerCommandRequest + Send,
{
    async fn send_pointer_input_command_to_tv<R: PointerInputCommand>(
        &mut self,
        cmd: R,
    ) -> Result<(), WebSocketError> {
        match self {
            ClientStateWebOs::Disconnected => Err(WebSocketError::Fatal),
            ClientStateWebOs::Connected(ref c) => {
                let mut c = c.lock().await;

                c.send_pointer_input_command_to_tv(cmd).await
            }
        }
    }
}

#[async_trait]
impl ClientState for ClientStateWebOs<WebOsClient> {
    async fn connect(&mut self, config: WebOsClientConfig) -> Result<String, WebSocketError> {
        let client = WebOsClient::connect(config).await?;

        let key = client.key.clone();
        *self = ClientStateWebOs::Connected(Arc::new(Mutex::new(client)));

        Ok(key)
    }

    async fn disconnect(&mut self) {
        *self = ClientStateWebOs::Disconnected;
    }
}

pub async fn try_to_connect<Client: ClientState>(
    client: Arc<Mutex<Client>>,
    info: &WebOsNetworkInfo,
) -> bool {
    let mut client_state = client.lock().await;

    let mut config = web_os_network_info_ffi::web_os_config_from_ip(&info.ip);
    //let try_to_connect = try_to_connect_to_tv(&mut *client_state, config).await;
    load_key_from_file(&mut config).await;

    log::debug!("Connecting to  TV");

    match client_state.connect(config).await {
        Ok(key) => {
            log::trace!("Connected to TV");
            save_key_on_file(key).await;
            if let Err(e) = web_os_network_info_ffi::save_last_webos_network_info(info).await {
                log::error!("Unable to save last web os network info in file {e:?}");
            }
            true
        }
        Err(e) => {
            log::error!("unable to connect to TV error {e:?}");
            false
        }
    }
}

const KEY_FILE: &str = "key.json";

async fn save_key_on_file(key: String) {
    let json_key = json!({ "key": key });

    match json_in_file::save_json(&json_key, KEY_FILE).await {
        Ok(_) => log::info!("key saved in file {KEY_FILE}"),
        Err(e) => log::error!("Unable to save key on file {KEY_FILE}, error: {e:?}"),
    };
}
async fn load_key_from_file(config: &mut WebOsClientConfig) {
    if config.key.is_some() {
        return;
    }

    let key = match json_in_file::load_json(KEY_FILE).await {
        Ok(json) => json["key"].as_str().map(|k| k.to_string()),
        Err(e) => {
            log::warn!("Unable to read key from {KEY_FILE} error: {e:?}");
            None
        }
    };
    config.key = key;
}

pub async fn send_lg_command<Cmd: LGCommandRequest + 'static, Client: ClientState>(
    client: Arc<Mutex<Client>>,
    cmd: Cmd,
) {
    let mut client_state = client.lock().await;
    let result = client_state.send_lg_command_to_tv(cmd).await;

    log::info!("response: {result:?}");
}

pub async fn send_pointer_command<Cmd: PointerInputCommand + 'static, Client: ClientState>(
    client: Arc<Mutex<Client>>,
    cmd: Cmd,
) {
    let mut client_state = client.lock().await;
    let result = client_state.send_pointer_input_command_to_tv(cmd).await;

    log::info!("response: {result:?}");
}

#[cfg(test)]
mod tests {
    use std::sync::Arc;

    use lg_webos_client::{
        discovery::WebOsNetworkInfo,
        lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
    };
    use serde_json::json;
    use tokio::sync::Mutex;

    use crate::{
        client_state::KEY_FILE,
        client_tasks::{try_to_connect_task, turn_on_task},
        json_in_file,
        mocks::{ErrorTurnOn, MockSucessSearch, MockWebOsClient, SucessTurnOn},
    };
    use lg_webos_client::lg_command::pointer_input_commands::Pointer;
    use lg_webos_client::lg_command::request_commands::system_launcher;

    use lg_webos_client::lg_command::pointer_input_commands::ButtonKey;

    use super::{send_lg_command, send_pointer_command};

    #[tokio::test]
    async fn test_start_connect() {
        // try to connect and turn on  have "file" race
        test_try_to_connect_task().await;
        test_turn_on().await;
    }

    async fn test_turn_on() {
        let mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
            input_lg: None,
            input_pointer: None,
            disconnect: false,
        };

        let client = Arc::new(Mutex::new(mock));

        let info = WebOsNetworkInfo {
            ip: "192.168.0.199".into(),
            name: "WebOS/1.5 UPnP/1.0 webOSTV/1.0".into(),
            mac_address: "03:a1:11:a6:0f:3e".into(),
        };

        let mut search = MockSucessSearch {
            infos: vec![info.clone()],
        };
        let mut turn_on = SucessTurnOn;

        let result = turn_on_task(
            client.clone(),
            Some(info.clone()),
            &mut turn_on,
            &mut search,
            0,
        )
        .await;

        assert!(result);

        // Error when WebOsNetworkInfoFFI can't be converted
        let result = turn_on_task(client.clone(), None, &mut turn_on, &mut search, 0).await;

        assert!(!result);

        // Error when  can't send the wake up command
        let mut turn_on = ErrorTurnOn;
        let result = turn_on_task(
            client.clone(),
            Some(info.clone()),
            &mut turn_on,
            &mut search,
            0,
        )
        .await;

        assert!(!result);

        // Error when the tv can't be found
        let mut search = MockSucessSearch { infos: vec![] };
        let mut turn_on = SucessTurnOn;

        let result = turn_on_task(
            client.clone(),
            Some(info.clone()),
            &mut turn_on,
            &mut search,
            0,
        )
        .await;

        assert!(!result);
    }

    async fn test_try_to_connect_task() {
        let mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
            input_lg: None,
            input_pointer: None,
            disconnect: false,
        };

        let client = Arc::new(Mutex::new(mock));

        let tv = WebOsNetworkInfo {
            ip: "192.168.0.199".into(),
            name: "WebOS/1.5 UPnP/1.0 webOSTV/1.0".into(),
            mac_address: "03:a1:11:a6:0f:3e".into(),
        };

        let result = try_to_connect_task(Some(tv.clone()), client.clone()).await;
        assert!(result);

        let last_tv = crate::web_os_network_info_ffi::load_last_webos_network_info()
            .await
            .unwrap();

        assert_eq!(tv.ip, last_tv.ip);
        assert_eq!(tv.mac_address, last_tv.mac_address);
        assert_eq!(tv.name, last_tv.name);

        let key = json_in_file::load_json(KEY_FILE).await.unwrap();
        let key = key["key"].as_str().unwrap();

        assert_eq!(key, "1123");

        let result = try_to_connect_task(None, client.clone()).await;
        assert!(!result);
    }

    #[tokio::test]
    async fn test_lg_commands() {
        let mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
            input_lg: None,
            input_pointer: None,
            disconnect: false,
        };

        let client = Arc::new(Mutex::new(mock));
        let cmds: Vec<Box<dyn LGCommandRequest>> = vec![
            Box::new(system_launcher::LaunchApp::youtube()),
            Box::new(system_launcher::LaunchApp::netflix()),
            Box::new(system_launcher::LaunchApp::amazon_prime_video()),
        ];

        for cmd in cmds {
            let expected_req = cmd.to_command_request();
            send_lg_command(client.clone(), cmd).await;
            let mock = client.lock().await;
            let req = mock.input_lg.as_ref().unwrap();
            crate::mocks::assert_req(&expected_req, req);
        }
    }

    #[tokio::test]
    async fn test_pointer_commands() {
        let mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
            input_lg: None,
            input_pointer: None,
            disconnect: false,
        };

        let client = Arc::new(Mutex::new(mock));
        let cmds: Vec<Box<dyn PointerInputCommand>> = vec![
            Box::new(Pointer::scroll(10f32, 10f32)),
            Box::new(Pointer::move_it(10f32, 2f32, true)),
            Box::new(ButtonKey::UP),
            Box::new(ButtonKey::DOWN),
            Box::new(ButtonKey::LEFT),
            Box::new(ButtonKey::RIGHT),
        ];

        for cmd in cmds {
            let expected = cmd.to_request_string();
            send_pointer_command(client.clone(), cmd).await;

            let mock = client.lock().await;
            let req = mock.input_pointer.as_ref().unwrap();

            assert_eq!(*req, expected);
        }
    }
}
