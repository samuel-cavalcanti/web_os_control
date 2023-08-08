use lg_webos_client::{client::WebOsClientConfig, discovery::WebOsNetworkInfo};
use serde_json::json;
use std::ffi::{c_char, CStr};

use crate::json_in_file;

#[repr(C)]
#[derive(Debug)]
pub struct WebOsNetworkInfoFFI {
    pub name: *const c_char,
    pub ip: *const c_char,
    pub mac: *const c_char,
}

impl WebOsNetworkInfoFFI {
    pub fn to_safe(&self) -> Option<WebOsNetworkInfo> {
        let info = WebOsNetworkInfo {
            name: c_string_to_rust_string(self.name)?,
            ip: c_string_to_rust_string(self.ip)?,
            mac_address: c_string_to_rust_string(self.mac)?,
        };

        Some(info)
    }
}

const LAST_NETWORK_INFO: &str = "last_network_info.json";

pub fn web_os_config_from_ip(ip_address: &String) -> WebOsClientConfig {
    WebOsClientConfig {
        address: format!("ws://{ip_address}:3000/"),
        key: None,
    }
}

pub fn to_json(info: &WebOsNetworkInfo) -> serde_json::Value {
    let json = json!({"name":info.name,
    "ip":info.ip,
    "mac":info.mac_address,
    });

    json
}

pub fn save_last_webos_network_info(
    info: &WebOsNetworkInfo,
) -> Result<(), json_in_file::JsonInFileError> {
    let json = to_json(info);

    json_in_file::save_json(&json, LAST_NETWORK_INFO)?;
    Ok(())
}

pub fn load_last_webos_network_info() -> Option<WebOsNetworkInfo> {
    let json = match json_in_file::load_json(LAST_NETWORK_INFO) {
        Ok(value) => value,
        Err(_e) => return None,
    };

    let ip = json["ip"].as_str()?;
    let mac = json["mac"].as_str()?;
    let name = json["name"].as_str()?;

    let info = WebOsNetworkInfo {
        ip: ip.to_string(),
        mac_address: mac.to_string(),
        name: name.to_string(),
    };

    Some(info)
}

fn c_string_to_rust_string(string: *const c_char) -> Option<String> {
    let c_string;
    if string.is_null() {
        return None;
    }
    unsafe {
        c_string = CStr::from_ptr(string);
    }

    let result = match c_string.to_str() {
        Ok(s) => Some(s),
        Err(e) => {
            log::error!("Unable to parse C string: {c_string:?} error: {e:?}");
            None
        }
    };
    let rust_string = result?.to_string();

    Some(rust_string)
}

#[cfg(test)]
mod tests {
    use lg_webos_client::discovery::WebOsNetworkInfo;

    use crate::web_os_network_info_ffi::{save_last_webos_network_info, web_os_config_from_ip};

    use super::{load_last_webos_network_info, WebOsNetworkInfoFFI, LAST_NETWORK_INFO};
    use std::ffi::CString;

    #[test]
    fn test_safe_convertion() {
        let ip = "192.168.0.200";
        let mac = "a2:a4:f4:22:04:05";
        let name = "test";
        let c_string_ip = CString::new(ip).unwrap();
        let c_string_mac = CString::new(mac).unwrap();
        let c_string_name = CString::new(name).unwrap();

        let info = WebOsNetworkInfoFFI {
            name: c_string_name.as_ptr(),
            ip: c_string_ip.as_ptr(),
            mac: c_string_mac.as_ptr(),
        };

        let safe_info = info.to_safe().unwrap();

        assert_eq!(safe_info.name, name.to_string());
        assert_eq!(safe_info.ip, ip.to_string());
        assert_eq!(safe_info.mac_address, mac.to_string());

        let null_infos = [
            WebOsNetworkInfoFFI {
                name: std::ptr::null(),
                ip: c_string_ip.as_ptr(),
                mac: c_string_mac.as_ptr(),
            },
            WebOsNetworkInfoFFI {
                name: c_string_name.as_ptr(),
                ip: std::ptr::null(),
                mac: c_string_mac.as_ptr(),
            },
            WebOsNetworkInfoFFI {
                name: c_string_name.as_ptr(),
                ip: c_string_ip.as_ptr(),
                mac: std::ptr::null(),
            },
        ];
        for info in null_infos {
            let safe_info = info.to_safe();
            assert!(safe_info.is_none());
        }
    }

    #[test]
    fn test_save_and_load_webos_info() {
        let ip = "192.168.0.200";
        let mac = "a2:a4:f4:22:04:05";
        let name = "test";
        let _result = std::fs::remove_file(LAST_NETWORK_INFO);

        let info = load_last_webos_network_info();
        assert!(info.is_none());

        let info = WebOsNetworkInfo {
            name: name.to_string(),
            ip: ip.to_string(),
            mac_address: mac.to_string(),
        };

        save_last_webos_network_info(&info).unwrap();

        let info = load_last_webos_network_info().unwrap();

        assert_eq!(info.name, name.to_string());
        assert_eq!(info.ip, ip.to_string());
        assert_eq!(info.mac_address, mac.to_string());
    }

    #[test]
    fn test_to_webos_config() {
        for ip_addres in ["192.168.0.200", "192.168.0.55", "lgwebostv.local"] {
            let ip_address = ip_addres.to_string();
            let config = web_os_config_from_ip(&ip_address);

            assert_eq!(config.address, format!("ws://{ip_addres}:3000/"));
            assert_eq!(config.key, None);
        }
    }
}
