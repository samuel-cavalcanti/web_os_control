
    use async_trait::async_trait;

    use lg_webos_client::discovery::WebOsNetworkInfo;

    use crate::discovery_tv::SearchTvs;

    pub struct MockSucessSearch {
       pub infos: Vec<WebOsNetworkInfo>,
    }
    pub struct MockErrorSearch;

    #[async_trait]
    impl SearchTvs for MockSucessSearch {
        async fn search(&mut self) -> Result<Vec<WebOsNetworkInfo>, String> {
            Ok(self.infos.clone())
        }
    }

    #[async_trait]
    impl SearchTvs for MockErrorSearch {
        async fn search(&mut self) -> Result<Vec<WebOsNetworkInfo>, String> {
            Err("Search error: SSDP error".into())
        }
    }
