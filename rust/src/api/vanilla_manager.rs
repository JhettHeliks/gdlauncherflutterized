use anyhow::{Context, Result};
use chrono::Local;
use reqwest::Client;
use serde::Deserialize;
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use crate::frb_generated::StreamSink;
use crate::api::downloader::DownloadProgress;
use futures_util::StreamExt;

#[derive(Deserialize, Debug)]
pub struct VersionManifestV2 {
    pub versions: Vec<VersionEntry>,
}

#[derive(Deserialize, Debug)]
pub struct VersionEntry {
    pub id: String,
    pub r#type: String,
    pub url: String,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct VersionInfo {
    pub id: String,
    pub downloads: VersionDownloads,
    pub libraries: Vec<Library>,
    pub asset_index: AssetIndexRef,
}

#[derive(Deserialize, Debug)]
pub struct VersionDownloads {
    pub client: DownloadArtifact,
}

#[derive(Deserialize, Debug)]
pub struct Library {
    pub name: String,
    pub downloads: LibraryDownloads,
}

#[derive(Deserialize, Debug)]
pub struct LibraryDownloads {
    pub artifact: Option<DownloadArtifact>,
    pub classifiers: Option<serde_json::Value>,
}

#[derive(Deserialize, Debug)]
pub struct DownloadArtifact {
    pub path: Option<String>,
    pub sha1: String,
    pub size: u32,
    pub url: String,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct AssetIndexRef {
    pub id: String,
    pub sha1: String,
    pub size: u32,
    pub total_size: u32,
    pub url: String,
}

#[derive(Deserialize, Debug)]
pub struct AssetIndex {
    pub objects: std::collections::HashMap<String, AssetObject>,
}

#[derive(Deserialize, Debug)]
pub struct AssetObject {
    pub hash: String,
    pub size: u32,
}

pub async fn get_vanilla_versions() -> Result<Vec<String>> {
    let client = Client::new();
    let res = client
        .get("https://launchermeta.mojang.com/mc/game/version_manifest_v2.json")
        .send()
        .await?
        .json::<VersionManifestV2>()
        .await?;
        
    let mut versions = Vec::new();
    for v in res.versions {
        if v.r#type == "release" {
            versions.push(v.id);
        }
    }
    
    Ok(versions)
}

pub async fn install_vanilla_version(
    version_id: String,
    instance_name: String,
    instance_path: String,
    progress_sink: StreamSink<DownloadProgress>,
) -> Result<()> {
    let client = Client::new();
    let instance_dir = PathBuf::from(&instance_path);
    
    let log_path = instance_dir.join("install.log");
    let mut log_file = File::options().create(true).append(true).open(&log_path)
        .or_else(|_| File::create(&log_path))?;
        
    let mut log_msg = |msg: &str| {
        let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S");
        let _ = writeln!(log_file, "[{}] {}", timestamp, msg);
    };
    
    log_msg(&format!("Starting vanilla install for {}, version {}", instance_name, version_id));
    
    let manifest = client
        .get("https://launchermeta.mojang.com/mc/game/version_manifest_v2.json")
        .send()
        .await?
        .json::<VersionManifestV2>()
        .await?;
        
    let version_entry = manifest.versions.into_iter().find(|v| v.id == version_id)
        .context("Version not found")?;
        
    log_msg("SUCCESS: Fetched main version manifest.");
        
    let version_info = client.get(&version_entry.url).send().await?.json::<VersionInfo>().await?;
    
    let bin_dir = instance_dir.join("bin");
    let libs_dir = instance_dir.join("libraries");
    let assets_dir = instance_dir.join("assets");
    let objects_dir = assets_dir.join("objects");
    let indexes_dir = assets_dir.join("indexes");
    
    std::fs::create_dir_all(&bin_dir)?;
    std::fs::create_dir_all(&libs_dir)?;
    std::fs::create_dir_all(&objects_dir)?;
    std::fs::create_dir_all(&indexes_dir)?;
    
    // 1. Download Client
    let _ = progress_sink.add(DownloadProgress { total_files: 1, downloaded_files: 0, current_file: "client.jar".to_string() });
    
    download_file_sync(&client, &version_info.downloads.client.url, &bin_dir.join("client.jar")).await?;
    log_msg("SUCCESS: downloaded client.jar");
    let _ = progress_sink.add(DownloadProgress { total_files: 1, downloaded_files: 1, current_file: "client.jar".to_string() });
    
    // 2. Download Libraries
    let mut libs_to_download = Vec::new();
    for lib in &version_info.libraries {
        if let Some(dl) = &lib.downloads.artifact {
            if let Some(path) = &dl.path {
                libs_to_download.push((dl.url.clone(), libs_dir.join(path)));
            }
        }
    }
    
    let total_libs = libs_to_download.len() as u32;
    for (i, (url, path)) in libs_to_download.into_iter().enumerate() {
        if let Some(parent) = path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        
        let file_name = path.file_name().unwrap_or_default().to_string_lossy().to_string();
        let _ = progress_sink.add(DownloadProgress {
            total_files: total_libs,
            downloaded_files: i as u32,
            current_file: file_name.clone(),
        });
        
        if !path.exists() {
            if let Err(e) = download_file_sync(&client, &url, &path).await {
                log_msg(&format!("FAILED: {} - {}", file_name, e));
            } else {
                log_msg(&format!("SUCCESS: {}", file_name));
            }
        }
    }
    let _ = progress_sink.add(DownloadProgress {
        total_files: total_libs,
        downloaded_files: total_libs,
        current_file: "Libraries synced".to_string(),
    });
    
    // 3. Asset Index
    let asset_index_path = indexes_dir.join(format!("{}.json", version_info.asset_index.id));
    if !asset_index_path.exists() {
        download_file_sync(&client, &version_info.asset_index.url, &asset_index_path).await?;
    }
    log_msg("SUCCESS: downloaded asset index");
    
    let asset_index_content = std::fs::read_to_string(&asset_index_path)?;
    let asset_index: AssetIndex = serde_json::from_str(&asset_index_content)?;
    
    let total_assets = asset_index.objects.len() as u32;
    let mut completed_assets = 0;
    
    let client_ref = &client;
    let objects_dir_ref = &objects_dir;
    
    let fetches = futures_util::stream::iter(asset_index.objects.into_iter().map(|(_name, obj)| {
        let hash = obj.hash.clone();
        async move {
            let parent_hash = &hash[0..2];
            let url = format!("https://resources.download.minecraft.net/{}/{}", parent_hash, hash);
            let target_dir = objects_dir_ref.join(parent_hash);
            let target_path = target_dir.join(&hash);
            
            if !target_path.exists() {
                let _ = std::fs::create_dir_all(&target_dir);
                let _ = download_file_sync(client_ref, &url, &target_path).await;
            }
            hash
        }
    })).buffer_unordered(25);
    
    let mut fetches = fetches;
    while let Some(hash) = fetches.next().await {
        completed_assets += 1;
        log_msg(&format!("SUCCESS: asset {}", hash));
        
        if completed_assets % 20 == 0 || completed_assets == total_assets {
            let _ = progress_sink.add(DownloadProgress {
                total_files: total_assets,
                downloaded_files: completed_assets,
                current_file: format!("Extracting Asset {}", hash),
            });
        }
    }
    
    log_msg("Installation fully completed!");
    
    Ok(())
}

async fn download_file_sync(client: &Client, url: &str, path: &Path) -> Result<()> {
    let response = client.get(url).send().await?;
    if !response.status().is_success() {
        return Err(anyhow::anyhow!("HTTP error {}", response.status()));
    }
    let bytes = response.bytes().await?;
    tokio::fs::write(path, bytes).await?;
    Ok(())
}
