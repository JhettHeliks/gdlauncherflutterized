use anyhow::anyhow;
use std::fs::File;
use std::io::Read;
use zip::ZipArchive;

#[derive(Debug, Clone)]
pub enum ModpackArchiveType {
    CurseForge,
    Modrinth,
}

#[derive(Debug, Clone)]
pub struct ParsedArchiveMetadata {
    pub name: String,
    pub version: String,
    pub archive_type: ModpackArchiveType,
    pub modloader: String,
}

pub fn analyze_modpack_archive(zip_path: String) -> anyhow::Result<ParsedArchiveMetadata> {
    let file = File::open(&zip_path)?;
    let mut archive = ZipArchive::new(file)?;

    // Check for Modrinth
    if let Ok(mut modrinth_manifest) = archive.by_name("modrinth.index.json") {
        let mut data = String::new();
        modrinth_manifest.read_to_string(&mut data)?;
        
        let parsed: serde_json::Value = serde_json::from_str(&data)?;
        
        let name = parsed["name"].as_str().unwrap_or("Unknown Modpack").to_string();
        let version = parsed["versionId"].as_str().unwrap_or("unknown").to_string();
        
        // Modrinth dependencies usually contain the modloader
        let mut modloader = "unknown".to_string();
        if let Some(deps) = parsed["dependencies"].as_object() {
            if deps.contains_key("fabric-loader") {
                modloader = "fabric".to_string();
            } else if deps.contains_key("forge") {
                modloader = "forge".to_string();
            } else if deps.contains_key("quilt-loader") {
                modloader = "quilt".to_string();
            } else if deps.contains_key("neoforge") {
                modloader = "neoforge".to_string();
            }
        }
        
        return Ok(ParsedArchiveMetadata {
            name,
            version,
            archive_type: ModpackArchiveType::Modrinth,
            modloader,
        });
    }

    // Check for CurseForge
    if let Ok(mut cf_manifest) = archive.by_name("manifest.json") {
        let mut data = String::new();
        cf_manifest.read_to_string(&mut data)?;
        
        let parsed: serde_json::Value = serde_json::from_str(&data)?;
        
        let name = parsed["name"].as_str().unwrap_or("Unknown Modpack").to_string();
        let version = parsed["version"].as_str().unwrap_or("unknown").to_string();
        
        let mut modloader = "unknown".to_string();
        if let Some(mc) = parsed.get("minecraft") {
            if let Some(loaders) = mc.get("modLoaders") {
                if let Some(loader) = loaders.get(0) {
                    modloader = loader["id"].as_str().unwrap_or("unknown").to_string();
                }
            }
        }
        
        return Ok(ParsedArchiveMetadata {
            name,
            version,
            archive_type: ModpackArchiveType::CurseForge,
            modloader,
        });
    }

    Err(anyhow!("Archive missing modrinth.index.json or manifest.json"))
}
