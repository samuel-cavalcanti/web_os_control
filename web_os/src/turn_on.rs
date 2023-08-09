use std::fmt::Debug;

use async_trait::async_trait;
use lg_webos_client::{
    discovery::WebOsNetworkInfo,
    wake_on_lan::{self, MagicPacket},
};

#[derive(Debug)]
pub enum WakeUPError {
    MagicPacketError,
    IoError,
}

#[async_trait]
pub trait TurnOnTV {
    type O;
    type E: Debug;
    async fn turn_on(&mut self, info: &WebOsNetworkInfo) -> Result<Self::O, Self::E>;
}

pub struct WakeUP;

#[async_trait]
impl TurnOnTV for WakeUP {
    type O = ();
    type E = WakeUPError;

    async fn turn_on(&mut self, info: &WebOsNetworkInfo) -> Result<(), WakeUPError> {
        let package = MagicPacket::from_mac_string(&info.mac_address);
        let package = match package {
            Some(p) => p,
            None => {
                return Err(WakeUPError::MagicPacketError);
            }
        };
        let address = format!("{}:9", &info.ip);

        match wake_on_lan::send_magic_packet_to_address(package, &address).await {
            Ok(_) => Ok(()),
            Err(_) => Err(WakeUPError::IoError),
        }
    }
}

