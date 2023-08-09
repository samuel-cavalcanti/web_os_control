mod mock_search_tvs;
mod mock_turn_on;
mod mock_webos_client;

pub use mock_search_tvs::{MockErrorSearch, MockSucessSearch};
pub use mock_turn_on::{ErrorTurnOn, SucessTurnOn};
pub use mock_webos_client::MockWebOsClient;

use lg_webos_client::lg_command::CommandRequest;
pub fn assert_req(cmd: &CommandRequest, expected_cmd: &CommandRequest) {
    assert_eq!(cmd.r#type, expected_cmd.r#type);
    assert_eq!(cmd.payload, expected_cmd.payload);
    assert_eq!(cmd.uri, expected_cmd.uri);
}
