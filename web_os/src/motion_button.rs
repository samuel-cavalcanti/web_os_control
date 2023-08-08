use lg_webos_client::lg_command::pointer_input_commands::ButtonKey;

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
    GUIDE,
    QMENU,
}
impl MotionButtonKeyFFI {
    pub fn to_button_key(&self) -> ButtonKey {
        match self {
            MotionButtonKeyFFI::HOME => ButtonKey::HOME,
            MotionButtonKeyFFI::BACK => ButtonKey::BACK,
            MotionButtonKeyFFI::UP => ButtonKey::UP,
            MotionButtonKeyFFI::DOWN => ButtonKey::DOWN,
            MotionButtonKeyFFI::LEFT => ButtonKey::LEFT,
            MotionButtonKeyFFI::RIGHT => ButtonKey::RIGHT,
            MotionButtonKeyFFI::ENTER => ButtonKey::ENTER,
            MotionButtonKeyFFI::GUIDE => ButtonKey::GUIDE,
            MotionButtonKeyFFI::QMENU => ButtonKey::QMENU,
        }
    }
}

#[cfg(test)]
mod tests {
    use lg_webos_client::lg_command::pointer_input_commands::{ButtonKey, PointerInputCommand};

    use crate::MotionButtonKeyFFI;

    #[test]
    fn test_motion_ffi_to_button_key() {
        let keys = [
            MotionButtonKeyFFI::HOME,
            MotionButtonKeyFFI::BACK,
            MotionButtonKeyFFI::GUIDE,
            MotionButtonKeyFFI::ENTER,
            MotionButtonKeyFFI::QMENU,
            // arrows
            MotionButtonKeyFFI::UP,
            MotionButtonKeyFFI::DOWN,
            MotionButtonKeyFFI::LEFT,
            MotionButtonKeyFFI::RIGHT,
        ];

        let expected_keys = [
            ButtonKey::HOME,
            ButtonKey::BACK,
            ButtonKey::GUIDE,
            ButtonKey::ENTER,
            ButtonKey::QMENU,
            // arrows
            ButtonKey::UP,
            ButtonKey::DOWN,
            ButtonKey::LEFT,
            ButtonKey::RIGHT,
        ];

        for (key, expected_key) in keys.iter().zip(expected_keys) {
            let button_key = key.to_button_key();

            assert_eq!(
                button_key.to_request_string(),
                expected_key.to_request_string()
            );
        }
    }
}
