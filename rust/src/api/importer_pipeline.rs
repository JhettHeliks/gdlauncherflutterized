use crate::api::settings_manager::load_settings;
use anyhow::{anyhow, Context};
use serde::{Deserialize, Serialize};
use std::fs::{self, File};
use std::io::{self, Read};
use std::path::{PathBuf};
use zip::ZipArchive;

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CurseForgeManifest {
    pub name: String,
    pub minecraft: CurseForgeMinecraft,
    pub files: Vec<CurseForgeFile>,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CurseForgeMinecraft {
    pub version: String,
    pub mod_loaders: Vec<CurseForgeModLoader>,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CurseForgeModLoader {
    pub id: String,
    pub primary: bool,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CurseForgeFile {
    #[serde(rename = "projectID")]
    pub project_id: i32,
    #[serde(rename = "fileID")]
    pub file_id: i32,
    pub required: bool,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CosmicInstance {
    pub name: String,
    pub mc_version: String,
    pub modloader: String,
}

pub fn extract_curseforge_zip(zip_path: String) -> anyhow::Result<(String, Vec<i32>)> {
    let file = File::open(&zip_path).context("Failed to open zip file")?;
    let mut archive = ZipArchive::new(file).context("Failed to parse zip archive")?;
    
    // Parse manifest first
    let manifest_str = {
        let mut manifest_file = archive.by_name("manifest.json").map_err(|_| anyhow!("Missing manifest.json"))?;
        let mut s = String::new();
        manifest_file.read_to_string(&mut s).context("Failed to read manifest.json")?;
        s
    };
    
    let manifest: CurseForgeManifest = serde_json::from_str(&manifest_str).context("Failed to parse manifest.json")?;
    
    // Determine destination directory using settings
    let settings = load_settings();
    let instance_dir = PathBuf::from(settings.instance_dir);
    
    // Sanitize modpack name explicitly
    let safe_name = manifest.name.replace(&['<', '>', ':', '"', '/', '\\', '|', '?', '*'][..], "_").trim().to_string();
    let dest_path = instance_dir.join(&safe_name);
    
    if !dest_path.exists() {
        fs::create_dir_all(&dest_path).context("Failed to create destination folder")?;
    }

    let modloader = manifest.minecraft.mod_loaders.iter()
        .find(|l| l.primary)
        .map_or("unknown".to_string(), |l| l.id.clone());
    
    // Create cosmic_instance.json
    let cosmic = CosmicInstance {
        name: manifest.name.clone(),
        mc_version: manifest.minecraft.version.clone(),
        modloader,
    };
    
    let cosmic_path = dest_path.join("cosmic_instance.json");
    fs::write(&cosmic_path, serde_json::to_string_pretty(&cosmic)?).context("Failed to write cosmic_instance.json")?;

    // Extract overrides directory
    for i in 0..archive.len() {
        let mut file = archive.by_index(i).context("Failed to read file from archive")?;
        
        let outpath = match file.enclosed_name() {
            Some(path) => path.to_owned(),
            None => continue,
        };
        
        // zip files store paths using forward slashes
        if let Ok(stripped) = outpath.strip_prefix("overrides") {
            let final_path = dest_path.join(stripped);
            
            if file.is_dir() {
                fs::create_dir_all(&final_path)?;
            } else {
                if let Some(p) = final_path.parent() {
                    if !p.exists() {
                        fs::create_dir_all(p)?;
                    }
                }
                let mut outfile = File::create(&final_path)?;
                io::copy(&mut file, &mut outfile)?;
            }
        }
    }
    
    let file_ids = manifest.files.into_iter().map(|f| f.file_id).collect();
    Ok((dest_path.to_string_lossy().to_string(), file_ids))
}
