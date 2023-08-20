use std::time::Duration;

use async_trait::async_trait;
use lg_webos_client::{
    client::{SendLgCommandRequest, SendPointerCommandRequest, WebOsClientConfig, WebSocketError},
    lg_command::{pointer_input_commands::PointerInputCommand, LGCommandRequest},
};
use serde_json::Value;

use crate::client_state::ClientState;

pub struct MockWebOsClientInfLoop {
    pub disconnect: bool,
}

#[async_trait]
impl SendLgCommandRequest for MockWebOsClientInfLoop {
    async fn send_lg_command_to_tv<R: LGCommandRequest>(
        &mut self,
        _cmd: R,
    ) -> Result<Value, WebSocketError> {
        tokio::time::sleep(Duration::from_secs(5)).await;

        Err(WebSocketError::Fatal)
    }
}

#[async_trait]
impl SendPointerCommandRequest for MockWebOsClientInfLoop {
    async fn send_pointer_input_command_to_tv<R: PointerInputCommand>(
        &mut self,
        _cmd: R,
    ) -> Result<(), WebSocketError> {
        tokio::time::sleep(Duration::from_secs(5)).await;

        Err(WebSocketError::Fatal)
    }
}

#[async_trait]
impl ClientState for MockWebOsClientInfLoop {
    async fn connect(&mut self, _config: WebOsClientConfig) -> Result<String, WebSocketError> {
        tokio::time::sleep(Duration::from_secs(5)).await;

        Err(WebSocketError::Fatal)
    }
    async fn disconnect(&mut self) {
        self.disconnect = true;
    }
}
