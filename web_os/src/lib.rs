use env_logger::Env;
use lazy_static::lazy_static;
use lg_webos_client::client::WebOsClient;
use lg_webos_client::discovery::WebOsNetworkInfo;
use lg_webos_client::lg_command::pointer_input_commands::{Pointer, PointerInputCommand};
use lg_webos_client::lg_command::request_commands::tv;
use lg_webos_client::lg_command::request_commands::{audio, system};
use lg_webos_client::lg_command::LGCommandRequest;
use lg_webos_client::wake_on_lan::MagicPacket;
use lg_webos_client::{discovery, wake_on_lan};
use log::debug;
use std::{future::Future, sync::Arc};
use tokio::runtime::Runtime;
use tokio::sync::Mutex;

mod json_in_file;

mod client_state;
use client_state::{ClientState, ClientStateWebOs};

lazy_static! {
    static ref RUNTIME: tokio::runtime::Runtime = Runtime::new().unwrap();
    static ref FFI_CLIENT: Arc<Mutex<ClientStateWebOs<WebOsClient>>> =
        Arc::new(Mutex::new(ClientStateWebOs::Disconnected));
}

fn spawn_future<F>(future: F)
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    RUNTIME.spawn(future);
}

async fn send_lg_command<Cmd: LGCommandRequest + 'static, Client: ClientState>(
    client: Arc<Mutex<Client>>,
    cmd: Cmd,
) {
    let mut client_state = client.lock().await;
    let result = client_state.send_lg_command_to_tv(cmd).await;

    log::info!("response: {result:?}");
}

async fn send_pointer_command<Cmd: PointerInputCommand + 'static, Client: ClientState>(
    cmd: Cmd,
    client: Arc<Mutex<Client>>,
) {
    let mut client_state = client.lock().await;
    let result = client_state.send_pointer_input_command_to_tv(cmd).await;

    log::info!("response: {result:?}");
}

#[no_mangle]
pub extern "C" fn debug_mode() {
    let env = Env::default().default_filter_or("debug");
    let _result = env_logger::Builder::from_env(env).try_init();
}

mod web_os_network_info_ffi;
pub use web_os_network_info_ffi::WebOsNetworkInfoFFI;
#[no_mangle]
pub extern "C" fn connect_to_tv(network_info: WebOsNetworkInfoFFI, isolate_port: i64) {
    debug!("connecting tocting to tvith Tokio Runtime ");
    let safe_info = match network_info.to_safe() {
        Some(i) => i,
        None => {
            log::error!("Unable to covert Info FFI to Info {network_info:?}");
            allo_isolate::Isolate::new(isolate_port).post(false);
            return;
        }
    };
    let future = connect_to_tv_by_info(safe_info, isolate_port);

    spawn_future(future);
}

async fn connect_to_tv_by_info(info: WebOsNetworkInfo, isolate_port: i64) {
    let result = try_to_connect(FFI_CLIENT.clone(), info).await;
    allo_isolate::Isolate::new(isolate_port).post(result);
}
async fn try_to_connect<Client: ClientState>(
    client: Arc<Mutex<Client>>,
    info: WebOsNetworkInfo,
) -> bool {
    let mut client_state = client.lock().await;

    let config = web_os_network_info_ffi::web_os_config_from_ip(&info.ip);
    let try_to_connect = client_state::try_to_connect_to_tv(&mut *client_state, config).await;
    let sucess = try_to_connect.is_ok();

    if sucess {
        if let Err(e) = web_os_network_info_ffi::save_last_webos_network_info(&info) {
            log::error!("Unable to save last web os network info in file {e:?}");
        }
    }

    sucess
}

#[no_mangle]
pub extern "C" fn turn_on(info: WebOsNetworkInfoFFI, isolate_port: i64) {
    let info = info.to_safe();
    let info = match info {
        Some(info) => info,
        None => {
            log::error!("Unable to covert Info FFI to Info {info:?}");
            allo_isolate::Isolate::new(isolate_port).post(false);
            return;
        }
    };
    let future = async move {
        let package = MagicPacket::from_mac_string(&info.mac_address);
        let package = match package {
            Some(p) => p,
            None => return,
        };

        log::trace!("Sending magic package to {info:?}");

        let ip = &info.ip;

        let _result = wake_on_lan::send_magic_packet_to_address(package, &format!("{ip}:9")).await;

        tokio::time::sleep(tokio::time::Duration::new(1, 0)).await;

        let mut infos = match discovery::discovery_webostv_by_ssdp().await {
            Ok(i) => i,
            Err(_) => {
                allo_isolate::Isolate::new(isolate_port).post(false);
                return;
            }
        };

        let find_tv = |infos: &Vec<WebOsNetworkInfo>| {
            infos
                .iter()
                .filter(|i| i.mac_address == info.mac_address)
                .count()
                > 0
        };

        let max_try = 15;
        let mut n_try = 0;

        while !find_tv(&infos) && n_try < max_try {
            infos = match discovery::discovery_webostv_by_ssdp().await {
                Ok(i) => i,
                Err(_) => {
                    allo_isolate::Isolate::new(isolate_port).post(false);
                    return;
                }
            };

            tokio::time::sleep(tokio::time::Duration::new(1, 0)).await;
            n_try += 1;
        }

        log::debug!("tvs: {infos:?}");

        connect_to_tv_by_info(info, isolate_port).await;
    };

    spawn_future(future);
}

#[no_mangle]
pub extern "C" fn discovery_tv(isolate_port: i64) {
    let future = async move {
        let task = allo_isolate::Isolate::new(isolate_port).task(async {
            let infos = discovery::discovery_webostv_by_ssdp().await;

            match infos {
                Ok(infos) => {
                    let data = infos
                        .into_iter()
                        .map(|info| [info.ip, info.name, info.mac_address].to_vec())
                        .collect::<Vec<Vec<String>>>();
                    Ok(data)
                }
                Err(e) => Err(format!("Search error: {e}")),
            }
        });

        match task.await {
            true => log::trace!("Isolate Task is sended with sucess"),
            false => log::error!("Isolate Task is NOT sended  port: {isolate_port}"),
        };
    };

    spawn_future(future);
}

#[no_mangle]
pub extern "C" fn turn_off() {
    debug!("Sending Turn TV Off with Tokio Runtime ");
    spawn_future(turn_off_and_disconect(FFI_CLIENT.clone()));
}

async fn turn_off_and_disconect<Client: ClientState>(client: Arc<Mutex<Client>>) {
    let mut client_state = client.lock().await;

    let _result = client_state.send_lg_command_to_tv(system::TurnOffTV).await;
    client_state.disconnect().await;
}

#[no_mangle]
pub extern "C" fn increment_volume() {
    debug!("Sending increment volume RUST with Tokio Runtime ");
    spawn_future(send_lg_command(FFI_CLIENT.clone(), audio::VolumeUP));
}
#[no_mangle]
pub extern "C" fn decrease_volume() {
    debug!("Sending decrease volume RUST with Tokio Runtime");
    spawn_future(send_lg_command(FFI_CLIENT.clone(), audio::VolumeDown));
}

#[no_mangle]
pub extern "C" fn set_mute(mute: bool) {
    debug!("Sending volume Mute  with Tokio Runtime ");

    spawn_future(send_lg_command(FFI_CLIENT.clone(), audio::SetMute { mute }));
}

#[no_mangle]
pub extern "C" fn increment_channel() {
    spawn_future(send_lg_command(FFI_CLIENT.clone(), tv::ChannelUp));
}

#[no_mangle]
pub extern "C" fn decrease_channel() {
    spawn_future(send_lg_command(FFI_CLIENT.clone(), tv::ChannelDown));
}

mod motion_button;
pub use motion_button::MotionButtonKeyFFI;

#[no_mangle]
pub extern "C" fn pressed_button(key: MotionButtonKeyFFI) {
    debug!("pressed button key: {key:?}");
    let pointer_command = key.to_button_key();
    spawn_future(send_pointer_command(pointer_command, FFI_CLIENT.clone()));
}

mod media_player_button;
pub use media_player_button::MediaPlayerButtonFFI;

#[no_mangle]
pub extern "C" fn pressed_media_player_button(key: MediaPlayerButtonFFI) {
    spawn_future(send_lg_command(FFI_CLIENT.clone(), key.to_command()));
}

mod launch_app;
pub use launch_app::LaunchAppFFI;
#[no_mangle]
pub extern "C" fn launch_app(app: LaunchAppFFI) {
    spawn_future(send_lg_command(FFI_CLIENT.clone(), app.to_launch_app()));
}

#[no_mangle]
pub extern "C" fn pointer_move_it(dx: f32, dy: f32, drag: bool) {
    spawn_future(send_pointer_command(
        Pointer::move_it(dx, dy, drag),
        FFI_CLIENT.clone(),
    ));
}

#[no_mangle]
pub extern "C" fn pointer_scroll(dx: f32, dy: f32) {
    spawn_future(send_pointer_command(
        Pointer::scroll(dx, dy),
        FFI_CLIENT.clone(),
    ));
}

#[no_mangle]
pub extern "C" fn pointer_click() {
    spawn_future(send_pointer_command(Pointer::click(), FFI_CLIENT.clone()));
}
