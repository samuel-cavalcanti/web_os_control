use std::sync::Arc;

use lg_webos_client::{
    client::{
        SendLgCommandRequest, SendPointerCommandRequest, WebOsClient, WebOsClientConfig,
        WebSocketErrorAction,
    },
    lg_command::{
        pointer_input_commands::PointerInputCommand,
        request_commands::{media_controls, system_launcher},
        LGCommandRequest,
    },
};
use log::{debug, error};
use serde_json::json;
use tokio::sync::Mutex;

use crate::{pointer_control, volume_control, LaunchAppFFI, MidiaPlayerButtonFFI};

pub enum ClientState<Client: SendLgCommandRequest + SendPointerCommandRequest> {
    Disconnected,
    Connected(Client),
}

const KEY_FILE: &str = "key.txt";
async fn connect(
    client_state: &mut ClientState<WebOsClient>,
    config: WebOsClientConfig,
) -> Result<(), WebSocketErrorAction> {
    if let ClientState::Connected(_) = client_state {
        *client_state = ClientState::Disconnected;
    }

    let config = if config.key.is_none() {
        let key = read_key_from_file().await;
        WebOsClientConfig {
            address: config.address,
            key,
        }
    } else {
        config
    };

    debug!("Connecting to  TV");
    match WebOsClient::connect(config).await {
        Ok(new_client) => {
            let key = new_client.key.clone().unwrap();
            *client_state = ClientState::Connected(new_client);
            match std::fs::write(KEY_FILE, key) {
                Ok(_) => log::info!("key saved in file {KEY_FILE}"),
                Err(e) => log::error!("Unable to save key on file {KEY_FILE}, error: {e}"),
            };
            debug!("Connected to TV");
            Ok(())
        }

        Err(e) => {
            error!("Error on connect to TV: {e:?}");
            Err(e)
        }
    }
}
async fn read_key_from_file() -> Option<String> {
    let key = match std::fs::read_to_string(KEY_FILE) {
        Ok(key) => Some(key),
        Err(e) => {
            log::warn!("Unable to read key from {KEY_FILE} error: {e}");
            None
        }
    };
    key
}

pub async fn try_to_connect_to_tv(
    client: Arc<Mutex<ClientState<WebOsClient>>>,
    address: String,
    key: Option<String>,
) -> Result<(), WebSocketErrorAction> {
    let mut client = client.lock().await;

    let config = WebOsClientConfig { address, key };
    connect(&mut client, config).await
}
pub async fn send_set_mute(client: Arc<Mutex<ClientState<WebOsClient>>>, mute: bool) {
    let mut client_state = client.lock().await;

    let result = volume_control::set_mute(&mut client_state, mute).await;

    disconect_client_on_error(&mut client_state, result);
}
pub async fn send_add_volume(client: Arc<Mutex<ClientState<WebOsClient>>>, volume: i8) {
    let mut client_state = client.lock().await;

    let result = volume_control::add_volume(&mut client_state, volume).await;
    disconect_client_on_error(&mut client_state, result);
}

pub async fn send_midia_player_command(
    client: Arc<Mutex<ClientState<WebOsClient>>>,
    key: MidiaPlayerButtonFFI,
) {
    let mut client_state = client.lock().await;

    let command: Box<dyn LGCommandRequest> = match key {
        MidiaPlayerButtonFFI::PLAY => Box::new(media_controls::Play),

        MidiaPlayerButtonFFI::PAUSE => Box::new(media_controls::Pause),
    };

    let result = match *client_state {
        ClientState::Disconnected => Err(WebSocketErrorAction::Fatal),
        ClientState::Connected(ref mut client) => client.send_lg_command_to_tv(command).await,
    };

    disconect_client_on_error(&mut client_state, result);
}

pub async fn send_launch_app_command(
    client_state: Arc<Mutex<ClientState<WebOsClient>>>,
    app: LaunchAppFFI,
) {
    let mut client_state = client_state.lock().await;

    let result = match *client_state {
        ClientState::Disconnected => Err(WebSocketErrorAction::Fatal),
        ClientState::Connected(ref mut client) => {
            let app_name = match app {
                LaunchAppFFI::YouTube => "youtube.leanback.v4",
                LaunchAppFFI::Netflix => "netflix",
                LaunchAppFFI::AmazonPrimeVideo => "amazon",
            };

            let command = system_launcher::LaunchApp {
                app_id: Some(app_name.to_string()),
                name: None,
                parameters: json!({}),
            };

            client.send_lg_command_to_tv(command).await
        }
    };

    disconect_client_on_error(&mut client_state, result);
}
pub async fn send_pointer_command<C: PointerInputCommand>(
    client_state: Arc<Mutex<ClientState<WebOsClient>>>,
    cmd: C,
) {
    let mut client_state = client_state.lock().await;

    let result = pointer_control::send_pointer_input_command(&mut client_state, cmd).await;

    disconect_client_on_error(&mut client_state, result);
}

fn disconect_client_on_error<O, E>(client: &mut ClientState<WebOsClient>, result: Result<O, E>) {
    if result.is_err() {
        *client = ClientState::Disconnected;
    }
}
