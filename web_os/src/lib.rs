mod client_state;
mod client_tasks;
mod discovery_tv;
mod json_in_file;
mod launch_app;
mod media_player_button;
mod motion_button;
mod turn_on;
mod web_os_network_info_ffi;

#[cfg(test)]
mod mocks;

use crate::turn_on::WakeUP;
use allo_isolate::IntoDart;
use lazy_static::lazy_static;
use lg_webos_client::client::WebOsClient;
use lg_webos_client::lg_command::request_commands::audio;
use lg_webos_client::lg_command::{pointer_input_commands::Pointer, request_commands::tv};
use log::debug;
use media_player_button::MediaPlayerButtonFFI;
use motion_button::MotionButtonKeyFFI;
use std::{future::Future, sync::Arc};
use tokio::sync::Mutex;
use web_os_network_info_ffi::WebOsNetworkInfoFFI;

use client_state::{send_lg_command, send_pointer_command, ClientStateWebOs};
use discovery_tv::SSDPSearch;
pub use launch_app::LaunchAppFFI;

lazy_static! {
    static ref RUNTIME: tokio::runtime::Runtime = tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .worker_threads(1)
        .build()
        .unwrap();
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

fn spawn_isolate_task<F>(isolate_port: i64, future: F)
where
    F: Future + Send + 'static,
    F::Output: Send + IntoDart + 'static,
{
    let future = async move {
        let task = allo_isolate::Isolate::new(isolate_port).task(future);

        match task.await {
            true => log::trace!("Isolate Task is sended with sucess"),
            false => log::error!("Isolate Task is NOT sended  port: {isolate_port}"),
        };
    };

    spawn_future(future);
}

#[no_mangle]
pub extern "C" fn debug_mode() {
    init_logger();
}
#[cfg(target_os = "android")]
fn init_logger() {
    android_logger::init_once(
        android_logger::Config::default().with_max_level(log::LevelFilter::Debug),
    );
}

#[cfg(target_os = "linux")]
fn init_logger() {
    let env = env_logger::Env::default().default_filter_or("debug");
    let _result = env_logger::Builder::from_env(env).try_init();
}

#[no_mangle]
pub extern "C" fn connect_to_tv(network_info: WebOsNetworkInfoFFI, isolate_port: i64) {
    let safe_info = network_info.to_safe();

    debug!("connecting to TV, tv: {safe_info:?}");

    spawn_isolate_task(isolate_port, async move {
        client_tasks::try_to_connect_task(safe_info, FFI_CLIENT.clone()).await
    });
}

#[no_mangle]
pub extern "C" fn load_last_tv_info(isolate_port: i64) {
    spawn_isolate_task(isolate_port, async {
        let info = web_os_network_info_ffi::load_last_webos_network_info().await;

        if let Some(info) = info {
            Some([info.ip, info.name, info.mac_address].to_vec())
        } else {
            None
        }
    });
}

#[no_mangle]
pub extern "C" fn turn_on(info: WebOsNetworkInfoFFI, isolate_port: i64) {
    let info = info.to_safe();
    spawn_isolate_task(isolate_port, async move {
        client_tasks::turn_on_task(info, &mut WakeUP).await
    });
}

#[no_mangle]
pub extern "C" fn discovery_tv(isolate_port: i64) {
    spawn_isolate_task(isolate_port, async {
        discovery_tv::search_tv_task(&mut SSDPSearch).await
    });
}

#[no_mangle]
pub extern "C" fn turn_off(isolate_port: i64) {
    debug!("Sending Turn TV Off with Tokio Runtime ");
    spawn_isolate_task(
        isolate_port,
        client_tasks::turn_off_task(FFI_CLIENT.clone()),
    );
}

#[no_mangle]
pub extern "C" fn increment_volume(isolate_port: i64) {
    debug!("Sending increment volume RUST with Tokio Runtime ");
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), audio::VolumeUP),
    );
}
#[no_mangle]
pub extern "C" fn decrease_volume(isolate_port: i64) {
    debug!("Sending decrease volume RUST with Tokio Runtime");
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), audio::VolumeDown),
    );
}

#[no_mangle]
pub extern "C" fn set_mute(mute: bool, isolate_port: i64) {
    debug!("Sending volume Mute  with Tokio Runtime ");

    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), audio::SetMute { mute }),
    );
}

#[no_mangle]
pub extern "C" fn increment_channel(isolate_port: i64) {
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), tv::ChannelUp),
    );
}

#[no_mangle]
pub extern "C" fn decrease_channel(isolate_port: i64) {
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), tv::ChannelDown),
    );
}

#[no_mangle]
pub extern "C" fn pressed_button(key: MotionButtonKeyFFI, isolate_port: i64) {
    debug!("pressed button key: {key:?}");
    let pointer_command = key.to_button_key();
    spawn_isolate_task(
        isolate_port,
        send_pointer_command(FFI_CLIENT.clone(), pointer_command),
    );
}

#[no_mangle]
pub extern "C" fn pressed_media_player_button(key: MediaPlayerButtonFFI, isolate_port: i64) {
    debug!("pressed media button key: {key:?}");
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), key.to_command()),
    );
}

#[no_mangle]
pub extern "C" fn launch_app(app: LaunchAppFFI, isolate_port: i64) {
    debug!("Launching app key: {app:?}");
    spawn_isolate_task(
        isolate_port,
        send_lg_command(FFI_CLIENT.clone(), app.to_launch_app()),
    );
}

#[no_mangle]
pub extern "C" fn pointer_move_it(dx: f32, dy: f32, drag: bool, isolate_port: i64) {
    spawn_isolate_task(
        isolate_port,
        send_pointer_command(FFI_CLIENT.clone(), Pointer::move_it(dx, dy, drag)),
    );
}

#[no_mangle]
pub extern "C" fn pointer_scroll(dx: f32, dy: f32, isolate_port: i64) {
    spawn_isolate_task(
        isolate_port,
        send_pointer_command(FFI_CLIENT.clone(), Pointer::scroll(dx, dy)),
    );
}

#[no_mangle]
pub extern "C" fn pointer_click(isolate_port: i64) {
    spawn_isolate_task(
        isolate_port,
        send_pointer_command(FFI_CLIENT.clone(), Pointer::click()),
    );
}
