use lg_webos_client::lg_command::{request_commands::media_controls, LGCommandRequest};

#[derive(Debug)]
#[repr(C)]
pub enum MediaPlayerButtonFFI {
    PLAY,
    PAUSE,
}

impl MediaPlayerButtonFFI {
    pub fn to_command(&self) -> Box<dyn LGCommandRequest> {
        match self {
            MediaPlayerButtonFFI::PLAY => Box::new(media_controls::Play),
            MediaPlayerButtonFFI::PAUSE => Box::new(media_controls::Pause),
        }
    }
}

#[cfg(test)]
mod tests {
    use lg_webos_client::lg_command::{request_commands::media_controls, LGCommandRequest};

    use crate::MediaPlayerButtonFFI;

    #[test]
    fn test_media_player_button_ffi_to_media_player_command() {
        let midia_player_keys = [MediaPlayerButtonFFI::PLAY, MediaPlayerButtonFFI::PAUSE];
        let expected_commands: [Box<dyn LGCommandRequest>; 2] = [
            Box::new(media_controls::Play),
            Box::new(media_controls::Pause),
        ];

        for (key, expected_command) in midia_player_keys.iter().zip(expected_commands) {
            let command = key.to_command().to_command_request();
            let expected = expected_command.to_command_request();

            assert_eq!(command.uri, expected.uri);
            assert_eq!(command.r#type, expected.r#type);
            assert_eq!(command.payload, expected.payload);
        }
    }
}
