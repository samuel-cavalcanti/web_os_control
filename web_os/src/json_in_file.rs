use std::io;

use serde_json::Value;

#[cfg(target_os = "android")]
const DIR: &str = "/data/data/com.example.web_os_control_flutter/files/";

#[cfg(target_os = "linux")]
const DIR: &str = "";

pub async fn save_json(json: &Value, file_name: &str) -> Result<(), JsonInFileError> {
    let string_json = match serde_json::to_string(&json) {
        Ok(string) => string,
        Err(e) => {
            log::error!("Unable to convert to json");
            return Err(JsonInFileError::Parser(e));
        }
    };

    let file_name = std::path::Path::new(DIR).join(file_name);

    match tokio::fs::write(&file_name, &string_json).await {
        Ok(_) => {
            let file = tokio::fs::File::open(&file_name)
                .await
                .map_err(JsonInFileError::Io)?;
            tokio::fs::File::sync_all(&file)
                .await
                .map_err(JsonInFileError::Io)?;
            log::info!("json saved in file {file_name:?},content: {string_json}");
        }
        Err(e) => {
            log::error!("Unable to save json in file {file_name:?}, error: {e}");
            return Err(JsonInFileError::Io(e));
        }
    };

    Ok(())
}

pub async fn load_json(file_name: &str) -> Result<Value, JsonInFileError> {
    let file_name = std::path::Path::new(DIR).join(file_name);

    let json_string = tokio::fs::read_to_string(&file_name)
        .await
        .map_err(JsonInFileError::Io)?;

    let json = serde_json::from_str::<Value>(&json_string).map_err(JsonInFileError::Parser);

    if json.is_err() {
        log::warn!("unable to convert to json: {json_string:#?} of file: {file_name:?}");
    }

    json
}

#[derive(Debug)]
pub enum JsonInFileError {
    Io(io::Error),
    Parser(serde_json::Error),
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{load_json, save_json};

    #[tokio::test]
    async fn test_save_and_load_json() {
        let json = json!({"a":1,"b":2, "test":3});

        let file_name = "test_save_json.json";
        save_json(&json, file_name).await.unwrap();

        let content = std::fs::read_to_string(file_name).unwrap();

        let expected = r#"{"a":1,"b":2,"test":3}"#;
        let expected = expected.to_string();

        assert_eq!(content, expected);

        let json = load_json(file_name).await.unwrap();

        let a = json["a"].as_i64().unwrap();
        let b = json["b"].as_i64().unwrap();
        let test = json["test"].as_i64().unwrap();

        assert_eq!(a, 1);
        assert_eq!(b, 2);
        assert_eq!(test, 3);
    }
}
