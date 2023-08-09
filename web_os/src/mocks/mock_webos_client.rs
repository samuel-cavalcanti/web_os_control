use async_trait::async_trait;
use lg_webos_client::{
    client::{SendLgCommandRequest, SendPointerCommandRequest, WebOsClientConfig, WebSocketError},
    lg_command::{pointer_input_commands::PointerInputCommand, CommandRequest, LGCommandRequest},
};
use serde_json::Value;

use crate::client_state::ClientState;

pub struct MockWebOsClient {
    pub result_lg: Result<Value, WebSocketError>,
    pub result_input: Result<(), WebSocketError>,
    pub result_connect: Result<String, WebSocketError>,
    pub input_lg: Option<CommandRequest>,
    pub input_pointer: Option<String>,
    pub disconnect: bool,
}

#[async_trait]
impl SendLgCommandRequest for MockWebOsClient {
    async fn send_lg_command_to_tv<R: LGCommandRequest>(
        &mut self,
        cmd: R,
    ) -> Result<Value, WebSocketError> {
        self.input_lg = Some(cmd.to_command_request());
        self.result_lg.clone()
    }
}

#[async_trait]
impl SendPointerCommandRequest for MockWebOsClient {
    async fn send_pointer_input_command_to_tv<R: PointerInputCommand>(
        &mut self,
        cmd: R,
    ) -> Result<(), WebSocketError> {
        self.input_pointer = Some(cmd.to_request_string());
        self.result_input.clone()
    }
}

#[async_trait]
impl ClientState for MockWebOsClient {
    async fn connect(&mut self, _config: WebOsClientConfig) -> Result<String, WebSocketError> {
        self.result_connect.clone()
    }
    async fn disconnect(&mut self) {
        self.disconnect = true;
    }
}
