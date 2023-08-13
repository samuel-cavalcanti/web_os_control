use std::sync::Arc;

use lg_webos_client::{discovery::WebOsNetworkInfo, lg_command::request_commands::system};
use tokio::sync::Mutex;

use crate::{
    client_state::{self, ClientState},
    discovery_tv::{wait_until_tv_is_on, SearchTvs},
    turn_on::TurnOnTV,
};

pub async fn turn_off_task<Client: ClientState>(client: Arc<Mutex<Client>>) -> bool {
    let mut client_state = client.lock().await;

    let result = client_state.send_lg_command_to_tv(system::TurnOffTV).await;
    client_state.disconnect().await;

    result.is_ok()
}

pub async fn try_to_connect_task<Client: ClientState>(
    info: Option<WebOsNetworkInfo>,
    client: Arc<Mutex<Client>>,
) -> bool {
    let info = match info {
        Some(info) => info,
        None => {
            log::error!("Unable to covert Info FFI to Info {info:?}");
            return false;
        }
    };
    client_state::try_to_connect(client, &info).await
}

pub async fn turn_on_task<Client: ClientState, S: SearchTvs, T: TurnOnTV>(
    client: Arc<Mutex<Client>>,
    info: Option<WebOsNetworkInfo>,
    turn_on_method: &mut T,
    search_method: &mut S,
    delay_in_secods: u64,
) -> bool {
    let info = match info {
        Some(info) => info,
        None => {
            log::error!("Unable to covert Info FFI to Info {info:?}");
            return false;
        }
    };

    if let Err(e) = turn_on_method.turn_on(&info).await {
        log::error!("Error on turn on TV, error: {e:?}");
        return false;
    }

    if let Err(e) = wait_until_tv_is_on(&info, delay_in_secods, search_method).await {
        log::error!("{e}");
        return false;
    }

    client_state::try_to_connect(client, &info).await
}

#[cfg(test)]
mod test {
    use lg_webos_client::discovery::WebOsNetworkInfo;
    use lg_webos_client::lg_command::{request_commands::system, LGCommandRequest};
    use serde_json::json;
    use std::sync::Arc;
    use tokio::sync::Mutex;

    use crate::client_tasks::turn_on_task;
    use crate::mocks::{assert_req, ErrorTurnOn, MockSucessSearch, SucessTurnOn};
    use crate::{client_tasks::turn_off_task, mocks::MockWebOsClient};

    #[tokio::test]
    async fn test_turn_off() {
        let mock = MockWebOsClient {
            result_connect: Ok("1123".to_owned()),
            result_input: Ok(()),
            result_lg: Ok(json!({"test":"ok"})),
            input_lg: None,
            input_pointer: None,
            disconnect: false,
        };
        let client = Arc::new(Mutex::new(mock));

        let ok = turn_off_task(client.clone()).await;

        let mock = client.lock().await;
        let cmd = mock.input_lg.as_ref().unwrap();

        assert!(mock.disconnect);
        assert!(ok);

        let expected_cmd = system::TurnOffTV.to_command_request();

        assert_req(cmd, &expected_cmd);
    }

    #[tokio::test]
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
}
