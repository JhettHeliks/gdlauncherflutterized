use anyhow::{Context, Result};
use futures_util::StreamExt;
use reqwest::Client;
use serde::Deserialize;
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;
use crate::frb_generated::StreamSink;
use chrono::Local;

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
struct CurseForgeFileResponse {
    data: Vec<CurseForgeFileData>,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
struct CurseForgeFileData {
    id: i32,
    file_name: String,
    download_url: Option<String>,
}

pub struct DownloadProgress {
    pub total_files: u32,
    pub downloaded_files: u32,
    pub current_file: String,
}

pub async fn download_curseforge_mods(
    instance_path: String,
    file_ids: Vec<i32>,
    api_key: String,
    progress_sink: StreamSink<DownloadProgress>,
) -> Result<()> {
    if file_ids.is_empty() {
        return Ok(());
    }

    let mods_dir = PathBuf::from(&instance_path).join("mods");
    if !mods_dir.exists() {
        std::fs::create_dir_all(&mods_dir).context("Failed to create mods directory")?;
    }

    let log_path = PathBuf::from(&instance_path).join("install.log");
    let mut log_file = File::options().create(true).append(true).open(&log_path)
        .context("Failed to create or open install.log")?;

    let client = Client::new();

    let body = serde_json::json!({ "fileIds": file_ids });
    let res = client
        .post("https://api.curseforge.com/v1/mods/files")
        .header("x-api-key", &api_key)
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .json(&body)
        .send()
        .await
        .context("Failed to send request to CurseForge API")?;

    if !res.status().is_success() {
        let status = res.status();
        let error_msg = res.text().await.unwrap_or_default();
        return Err(anyhow::anyhow!("CurseForge API error: {} - {}", status, error_msg));
    }

    let cf_res: CurseForgeFileResponse = res.json().await.context("Failed to parse CurseForge API response")?;

    let total_files = file_ids.len() as u32;
    let mut downloaded_files = 0;

    for file_data in cf_res.data {
        let download_url = match file_data.download_url {
            Some(url) => url,
            None => {
                let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S");
                let _ = writeln!(log_file, "[{}] FAILED: {} - No download URL provided", timestamp, file_data.file_name);
                continue;
            }
        };

        let file_path = mods_dir.join(&file_data.file_name);
        let mut dest = match File::create(&file_path) {
            Ok(f) => f,
            Err(_) => {
                let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S");
                let _ = writeln!(log_file, "[{}] FAILED: {} - File creation failed", timestamp, file_data.file_name);
                continue;
            }
        };

        let response = client.get(&download_url).send().await?;
        if !response.status().is_success() {
            let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S");
            let _ = writeln!(log_file, "[{}] FAILED: {} - HTTP HTTP {}", timestamp, file_data.file_name, response.status());
            return Err(anyhow::anyhow!("Download failed for {}", file_data.file_name));
        }

        let mut stream = response.bytes_stream();
        while let Some(chunk) = stream.next().await {
            let chunk = chunk?;
            dest.write_all(&chunk)?;
        }
        
        let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S");
        let _ = writeln!(log_file, "[{}] SUCCESS: {}", timestamp, file_data.file_name);
        
        downloaded_files += 1;
        
        let _ = progress_sink.add(DownloadProgress {
            total_files,
            downloaded_files,
            current_file: file_data.file_name,
        });
    }

    Ok(())
}
