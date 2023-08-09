use async_trait::async_trait;
use lg_webos_client::discovery;
use lg_webos_client::discovery::WebOsNetworkInfo;

#[async_trait]
pub trait SearchTvs {
    async fn search(&mut self) -> Result<Vec<WebOsNetworkInfo>, String>;
}

pub struct SSDPSearch;

#[async_trait]
impl SearchTvs for SSDPSearch {
    async fn search(&mut self) -> Result<Vec<WebOsNetworkInfo>, String> {
        let infos = discovery::discovery_webostv_by_ssdp().await;

        match infos {
            Ok(infos) => Ok(infos),
            Err(e) => Err(format!("Search error: {e}")),
        }
    }
}

pub async fn search_tv_task<S: SearchTvs>(
    search_method: &mut S,
) -> Result<Vec<Vec<String>>, String> {
    match search_method.search().await {
        Ok(infos) => {
            let data = infos
                .into_iter()
                .map(|info| [info.ip, info.name, info.mac_address].to_vec())
                .collect::<Vec<Vec<String>>>();
            Ok(data)
        }
        Err(e) => Err(format!("Search error: {e}")),
    }
}

pub async fn wait_until_tv_is_on<S: SearchTvs>(
    tv: &WebOsNetworkInfo,
    delay_in_sec: u64,
    search_method: &mut S,
) -> Result<(), String> {
    let find_tv = |infos: &Vec<WebOsNetworkInfo>| {
        infos
            .iter()
            .filter(|i| i.mac_address == tv.mac_address)
            .count()
            > 0
    };

    let mut infos = search_method.search().await?;

    let max_try = 15;

    for _ in 0..max_try {
        if find_tv(&infos) {
            log::debug!("tvs: {infos:?}");
            return Ok(());
        }

        tokio::time::sleep(tokio::time::Duration::new(delay_in_sec, 0)).await;

        infos = search_method.search().await?;
    }

    Err("Execed Max Tries: {max_try}".into())
}

#[cfg(test)]
mod tests {

    use lg_webos_client::discovery::WebOsNetworkInfo;

    use crate::mocks::{MockSucessSearch, MockErrorSearch};

    use super::{search_tv_task, wait_until_tv_is_on};



    #[tokio::test]
    async fn test_search_tv_task() {
        let expected_tv = vec![
            "192.168.0.199",
            "WebOS/1.5 UPnP/1.0 webOSTV/1.0",
            "03:a1:11:a6:0f:3e",
        ];
        let mut mock = MockSucessSearch {
            infos: vec![WebOsNetworkInfo {
                ip: "192.168.0.199".into(),
                name: "WebOS/1.5 UPnP/1.0 webOSTV/1.0".into(),
                mac_address: "03:a1:11:a6:0f:3e".into(),
            }],
        };

        let tvs = search_tv_task(&mut mock).await.unwrap();

        assert_eq!(tvs.len(), 1);

        let tv = &tvs[0];

        for i in 0..3 {
            assert_eq!(tv[i], expected_tv[i].to_string())
        }
    }
    #[tokio::test]
    async fn test_wait_until_tv_is_on() {
        let mut mock = MockSucessSearch {
            infos: vec![WebOsNetworkInfo {
                ip: "192.168.0.199".into(),
                name: "WebOS/1.5 UPnP/1.0 webOSTV/1.0".into(),
                mac_address: "03:a1:11:a6:0f:3e".into(),
            }],
        };

        let info = WebOsNetworkInfo {
            ip: "192.168.0.199".into(),
            name: "WebOS/1.5 UPnP/1.0 webOSTV/1.0".into(),
            mac_address: "03:a1:11:a6:0f:3e".into(),
        };

        wait_until_tv_is_on(&info, 0, &mut mock).await.unwrap();

        mock = MockSucessSearch{infos:vec![]};

        let error =wait_until_tv_is_on(&info, 0, &mut mock).await;
        assert!(error.is_err());

        let mut mock = MockErrorSearch;

        let error =wait_until_tv_is_on(&info, 0, &mut mock).await;
        assert!(error.is_err());

    }
}
