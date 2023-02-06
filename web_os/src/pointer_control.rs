use lg_webos_client::{
    client::{SendLgCommandRequest, SendPointerCommandRequest, WebSocketErrorAction},
    lg_command::pointer_input_commands::PointerInputCommand,
};

use crate::ClientState;

pub async fn send_pointer_input_command<
    Cmd: PointerInputCommand,
    C: SendLgCommandRequest + SendPointerCommandRequest,
>(
    client_state: &mut ClientState<C>,
    cmd: Cmd,
) -> Result<(), WebSocketErrorAction> {
    match client_state {
        ClientState::Disconnected => Err(WebSocketErrorAction::Fatal),
        ClientState::Connected(ref mut client) => {
            client.send_pointer_input_command_to_tv(cmd).await
        }
    }
}
