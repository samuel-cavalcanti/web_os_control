use async_trait::async_trait;
use lg_webos_client::discovery::WebOsNetworkInfo;

use crate::turn_on::{TurnOnTV, WakeUPError};

pub struct SucessTurnOn;
pub struct ErrorTurnOn;

#[async_trait]
impl TurnOnTV for SucessTurnOn {
    type O = ();
    type E = WakeUPError;
    async fn turn_on(&mut self, _info: &WebOsNetworkInfo) -> Result<Self::O, Self::E> {
        Ok(())
    }
}

#[async_trait]
impl TurnOnTV for ErrorTurnOn {
    type O = ();
    type E = WakeUPError;
    async fn turn_on(&mut self, _info: &WebOsNetworkInfo) -> Result<Self::O, Self::E> {
        Err(WakeUPError::IoError)
    }
}
