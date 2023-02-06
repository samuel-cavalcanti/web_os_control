use crate::ClientState;
use lg_webos_client::client::{SendLgCommandRequest, SendPointerCommandRequest};
use lg_webos_client::lg_command::request_commands::audio::{GetVolume, SetVolume};
use lg_webos_client::{client::WebSocketErrorAction, lg_command::request_commands::audio::SetMute};
use log::{debug, error};

pub async fn set_mute<C: SendLgCommandRequest + SendPointerCommandRequest>(
    client_state: &mut ClientState<C>,
    mute: bool,
) -> Result<(), WebSocketErrorAction> {
    let set_mute_cmd = SetMute { mute };
    if let ClientState::Connected(ref mut client) = *client_state {
        let _result = client.send_lg_command_to_tv(set_mute_cmd).await?;
        Ok(())
    } else {
        Err(WebSocketErrorAction::Fatal)
    }
}

pub async fn add_volume<C: SendLgCommandRequest + SendPointerCommandRequest>(
    client_state: &mut ClientState<C>,
    volume: i8,
) -> Result<(), WebSocketErrorAction> {
    match client_state {
        ClientState::Disconnected => Err(WebSocketErrorAction::Fatal),
        ClientState::Connected(ref mut client) => send_increment_volume_to_tv(client, volume).await,
    }
}
async fn send_increment_volume_to_tv<C: SendLgCommandRequest + SendPointerCommandRequest>(
    client: &mut C,
    increment: i8,
) -> Result<(), WebSocketErrorAction> {
    let volume = get_current_volume_from_tv(client).await?;
    let set_volume = SetVolume {
        volume: volume + increment,
    };

    let json = client.send_lg_command_to_tv(set_volume).await?;
    debug!("Resonse:{json:?}");

    Ok(())
}

async fn get_current_volume_from_tv<C: SendLgCommandRequest + SendPointerCommandRequest>(
    client: &mut C,
) -> Result<i8, WebSocketErrorAction> {
    let json = client.send_lg_command_to_tv(GetVolume).await?;
    let volume = json["payload"]["volume"].as_i64();

    match volume {
        Some(number) => Ok(number as i8),
        None => {
            error!("error on getting volume from response: {json}");
            Err(WebSocketErrorAction::Continue)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use async_trait::async_trait;
    use lg_webos_client::{
        client::{SendLgCommandRequest, WebSocketErrorAction},
        lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
    };
    use serde_json::Value;

    struct MockSend {
        case: TestCase,
    }
    enum TestCase {
        GetVolume,
        WebSocketError,
    }
    fn get_audio_response() -> Value {
        let get_audio_response = r#"
    {"id":2,"payload":{"muted":true,"returnValue":true,"scenario":"mastervolume_tv_speaker","volume":15},"type":"response"}
    "#;

        serde_json::from_str::<Value>(get_audio_response).unwrap()
    }

    //fn get_set_audio_response() -> Value {
    //    serde_json::from_str(r#"{"id":3,"payload":{"returnValue":true},"type":"response"}"#)
    //        .unwrap()
    //}
    #[async_trait]
    impl SendLgCommandRequest for MockSend {
        async fn send_lg_command_to_tv<R: LGCommandRequest>(
            &mut self,
            _cmd: R,
        ) -> Result<Value, WebSocketErrorAction> {
            match self.case {
                TestCase::GetVolume => Ok(get_audio_response()),
                TestCase::WebSocketError => Err(WebSocketErrorAction::Fatal),
            }
        }
    }
    #[async_trait]
    impl SendPointerCommandRequest for MockSend {
        async fn send_pointer_input_command_to_tv<R: PointerInputCommand>(
            &mut self,
            _cmd: R,
        ) -> Result<(), WebSocketErrorAction> {
            Ok(())
        }
    }

    #[tokio::test]
    async fn test_get_current_volume_from_tv() {
        let mut mock = MockSend {
            case: TestCase::GetVolume,
        };

        let volume = get_current_volume_from_tv(&mut mock).await.unwrap();

        mock.case = TestCase::WebSocketError;

        let result = get_current_volume_from_tv(&mut mock).await;

        assert_eq!(result.is_err(), true);

        assert_eq!(volume, 15);
    }
}
