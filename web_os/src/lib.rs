use env_logger::Env;
use lg_webos_client::client::WebOsClient;
use lg_webos_client::lg_command::pointer_input_commands::{ButtonKey, Pointer};
use log::debug;
use std::ffi::{c_char, CStr};
use std::{future::Future, sync::Arc};
use tokio::{runtime::Runtime, sync::Mutex};

mod client_state;
mod pointer_control;
mod volume_control;
use client_state::ClientState;
thread_local! {
    static RUNTIME: tokio::runtime::Runtime = Runtime::new().unwrap();
    static FFI_CLIENT: Arc<Mutex<ClientState<WebOsClient>>> = Arc::new(Mutex::new(ClientState::Disconnected));
}

fn spawn_future<F>(future: F)
where
    F: Future + Send + 'static,
    F::Output: Send + 'static,
{
    RUNTIME.with(|rt| rt.spawn(future));
}

#[no_mangle]
pub extern "C" fn debug_mode() {
    let env = Env::default().default_filter_or("debug");
    // .default_write_style_or("always");
    let _result = env_logger::Builder::from_env(env).try_init();
}

#[no_mangle]
pub extern "C" fn connect_to_tv(address: *const c_char, key: *const c_char) {
    // Using Dart null safe, I'm sure that the address and key are not null
    let address = unsafe { CStr::from_ptr(address) };
    let key = unsafe { CStr::from_ptr(key) };

    let address = address.to_string_lossy().to_string();
    let key = key.to_string_lossy().to_string();

    let key = if key.is_empty() { None } else { Some(key) };
    FFI_CLIENT.with(|client| {
        let future = client_state::try_to_connect_to_tv(client.clone(), address, key);
        spawn_future(future);
    });
}

#[no_mangle]
pub extern "C" fn increment_volume() {
    debug!("Increment volume RUST with Tokio Runtime ");

    FFI_CLIENT.with(|client| {
        let future = client_state::send_add_volume(client.clone(), 1);
        spawn_future(future);
    });
}
#[no_mangle]
pub extern "C" fn decrease_volume() {
    debug!("Decrease Volume RUST with Tokio Runtime");

    FFI_CLIENT.with(|client| {
        let future = client_state::send_add_volume(client.clone(), -1);
        spawn_future(future);
    });
}

#[no_mangle]
pub extern "C" fn set_mute(mute: bool) {
    debug!("Set Volume Mute RUST with Tokio Runtime ");

    FFI_CLIENT.with(|client| {
        let future = client_state::send_set_mute(client.clone(), mute);

        spawn_future(future);
    });
}

#[derive(Debug)]
#[repr(C)]
pub enum MotionButtonKeyFFI {
    HOME,
    BACK,
    UP,
    DOWN,
    LEFT,
    RIGHT,
    ENTER,
}
#[no_mangle]
pub extern "C" fn pressed_button(key: MotionButtonKeyFFI) {
    debug!("pressed button key: {key:?}");
    FFI_CLIENT.with(|client| {
        let pointer_command = match key {
            MotionButtonKeyFFI::HOME => ButtonKey::HOME,
            MotionButtonKeyFFI::BACK => ButtonKey::BACK,
            MotionButtonKeyFFI::UP => ButtonKey::UP,
            MotionButtonKeyFFI::DOWN => ButtonKey::DOWN,
            MotionButtonKeyFFI::LEFT => ButtonKey::LEFT,
            MotionButtonKeyFFI::RIGHT => ButtonKey::RIGHT,
            MotionButtonKeyFFI::ENTER => ButtonKey::ENTER,
        };

        let future = client_state::send_pointer_command(client.clone(), pointer_command);

        spawn_future(future);
    });
}

#[derive(Debug)]
#[repr(C)]
pub enum MidiaPlayerButtonFFI {
    PLAY,
    PAUSE,
}

#[no_mangle]
pub extern "C" fn pressed_midia_player_button(key: MidiaPlayerButtonFFI) {
    FFI_CLIENT.with(|client| {
        let future = client_state::send_midia_player_command(client.clone(), key);

        spawn_future(future);
    });
}
#[derive(Debug)]
#[repr(C)]
pub enum LaunchAppFFI {
    YouTube,
    Netflix,
    AmazonPrimeVideo,
}

#[no_mangle]
pub extern "C" fn launch_app(app: LaunchAppFFI) {
    FFI_CLIENT.with(|client| {
        let future = client_state::send_launch_app_command(client.clone(), app);

        spawn_future(future);
    });
}

#[no_mangle]
pub extern "C" fn pointer_move_it(dx: f32, dy: f32, drag: bool) {
    FFI_CLIENT.with(|client| {
        let pointer_command = Pointer::move_it(dx, dy, drag);
        let future = client_state::send_pointer_command(client.clone(), pointer_command);

        spawn_future(future);
    });
}

#[no_mangle]
pub extern "C" fn pointer_scroll(dx: f32, dy: f32) {
    FFI_CLIENT.with(|client| {
        let pointer_command = Pointer::scroll(dx, dy);
        let future = client_state::send_pointer_command(client.clone(), pointer_command);

        spawn_future(future);
    });
}

#[no_mangle]
pub extern "C" fn pointer_click() {
    FFI_CLIENT.with(|client| {
        let pointer_command = Pointer::click();
        let future = client_state::send_pointer_command(client.clone(), pointer_command);

        spawn_future(future);
    });
}
