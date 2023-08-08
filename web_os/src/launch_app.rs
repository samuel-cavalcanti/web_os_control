use lg_webos_client::lg_command::request_commands::system_launcher;

#[derive(Debug)]
#[repr(C)]
pub enum LaunchAppFFI {
    YouTube,
    Netflix,
    AmazonPrimeVideo,
}

impl LaunchAppFFI {
    pub fn to_launch_app(&self) -> system_launcher::LaunchApp {
        match self {
            LaunchAppFFI::YouTube => system_launcher::LaunchApp::youtube(),
            LaunchAppFFI::Netflix => system_launcher::LaunchApp::netflix(),
            LaunchAppFFI::AmazonPrimeVideo => system_launcher::LaunchApp::amazon_prime_video(),
        }
    }
}

#[cfg(test)]
mod tests {
    use lg_webos_client::lg_command::request_commands::system_launcher;

    use crate::LaunchAppFFI;

    #[test]
    fn test_launch_ffi_to_launch_app() {
        let apps = [
            LaunchAppFFI::YouTube,
            LaunchAppFFI::Netflix,
            LaunchAppFFI::AmazonPrimeVideo,
        ];

        let expected_apps = [
            system_launcher::LaunchApp::youtube(),
            system_launcher::LaunchApp::netflix(),
            system_launcher::LaunchApp::amazon_prime_video(),
        ];

        for (app, expected) in apps.iter().zip(expected_apps) {
            let launch_app = app.to_launch_app();
            assert_eq!(launch_app.name, expected.name);
            assert_eq!(launch_app.app_id, expected.app_id);
            assert_eq!(launch_app.parameters, expected.parameters);
        }
    }
}
