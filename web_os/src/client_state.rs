use async_trait::async_trait;
use lg_webos_client::{
    client::{
        SendLgCommandRequest, SendPointerCommandRequest, WebOsClient, WebOsClientConfig,
        WebSocketError,
    },
    lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
};
use serde_json::{json, Value};
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::json_in_file;

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
            ClientStateWebOs::Connected(ref c) => send_lg_command(c.clone(), cmd).await,
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
            ClientStateWebOs::Connected(ref c) => send_pointer_command(c.clone(), cmd).await,
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

const KEY_FILE: &str = "key.json";
pub async fn try_to_connect_to_tv<CS: ClientState>(
    client_state: &mut CS,
    config: WebOsClientConfig,
) -> Result<(), WebSocketError> {
    let mut config = config;

    load_key_from_file(&mut config);

    log::debug!("Connecting to  TV");
    match client_state.connect(config).await {
        Ok(key) => {
            log::trace!("Connected to TV");
            save_key_on_file(key);
            Ok(())
        }
        Err(e) => {
            log::error!("unable to connect to TV error {e:?}");
            Err(e)
        }
    }
}

fn save_key_on_file(key: String) {
    let json_key = json!({ "key": key });

    match json_in_file::save_json(&json_key, KEY_FILE) {
        Ok(_) => log::info!("key saved in file {KEY_FILE}"),
        Err(e) => log::error!("Unable to save key on file {KEY_FILE}, error: {e:?}"),
    };
}
fn load_key_from_file(config: &mut WebOsClientConfig) {
    if config.key.is_some() {
        return;
    }

    let key = match json_in_file::load_json(KEY_FILE) {
        Ok(json) => json["key"].as_str().map(|k| k.to_string()),
        Err(e) => {
            log::warn!("Unable to read key from {KEY_FILE} error: {e:?}");
            None
        }
    };
    config.key = key;
}

type ResultClient<O> = Result<O, WebSocketError>;
pub async fn send_pointer_command<C: PointerInputCommand, Client: SendPointerCommandRequest>(
    client: Arc<Mutex<Client>>,
    cmd: C,
) -> ResultClient<()> {
    let mut client = client.lock().await;

    client.send_pointer_input_command_to_tv(cmd).await
}

pub async fn send_lg_command<Client: SendLgCommandRequest, Cmd: LGCommandRequest>(
    client: Arc<Mutex<Client>>,
    cmd: Cmd,
) -> ResultClient<Value> {
    let mut client = client.lock().await;

    client.send_lg_command_to_tv(cmd).await
}

#[cfg(test)]
mod tests {
    use async_trait::async_trait;
    use lg_webos_client::{
        client::{
            SendLgCommandRequest, SendPointerCommandRequest, WebOsClientConfig, WebSocketError,
        },
        lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
    };
    use serde_json::{json, Value};

    use crate::{client_state::KEY_FILE, json_in_file};

    use super::{try_to_connect_to_tv, ClientState};

    struct MockWebOsClient {
        result_lg: Result<Value, WebSocketError>,
        result_input: Result<(), WebSocketError>,
        result_connect: Result<String, WebSocketError>,
    }

    #[async_trait]
    impl SendLgCommandRequest for MockWebOsClient {
        async fn send_lg_command_to_tv<R: LGCommandRequest>(
            &mut self,
            _cmd: R,
        ) -> Result<Value, WebSocketError> {
            self.result_lg.clone()
        }
    }

    #[async_trait]
    impl SendPointerCommandRequest for MockWebOsClient {
        async fn send_pointer_input_command_to_tv<R: PointerInputCommand>(
            &mut self,
            _cmd: R,
        ) -> Result<(), WebSocketError> {
            self.result_input.clone()
        }
    }

    #[async_trait]
    impl ClientState for MockWebOsClient {
        async fn connect(&mut self, _config: WebOsClientConfig) -> Result<String, WebSocketError> {
            self.result_connect.clone()
        }
        async fn disconnect(&mut self) {}
    }

    #[tokio::test]
    async fn test_try_to_connect_to_tv() {
        let mut mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
        };

        try_to_connect_to_tv(&mut mock, WebOsClientConfig::default())
            .await
            .unwrap();

        let key = json_in_file::load_json(KEY_FILE).unwrap();
        let key = key["key"].as_str().unwrap();

        assert_eq!(key, "1123");
    }
}
