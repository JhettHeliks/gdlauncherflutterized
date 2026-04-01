use directories::UserDirs;

use std::fs;
use std::path::PathBuf;

#[derive(Debug, Clone)]
pub struct ImportableInstance {
    pub name: String,
    pub mc_version: String,
    pub modloader: String,
    pub path: String,
    pub icon_path: Option<String>,
}



pub fn scan_curseforge_instances() -> Vec<ImportableInstance> {
    let mut instances = Vec::new();

    let userdirs = match UserDirs::new() {
        Some(dirs) => dirs,
        None => return instances,
    };

    #[cfg(not(target_os = "windows"))]
    let base_dir = match userdirs.document_dir() {
        Some(dir) => dir.to_path_buf(),
        None => return instances,
    };
    
    #[cfg(target_os = "windows")]
    let base_dir = userdirs.home_dir().to_path_buf();

    let instances_dir = base_dir.join("curseforge").join("minecraft").join("Instances");

    if !instances_dir.is_dir() {
        return instances;
    }

    if let Ok(entries) = fs::read_dir(instances_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir() {
                if let Some(instance) = scan_single_instance(&path) {
                    instances.push(instance);
                }
            }
        }
    }

    instances
}

fn scan_single_instance(path: &PathBuf) -> Option<ImportableInstance> {
    let config_path = path.join("minecraftinstance.json");
    if !config_path.is_file() {
        return None;
    }

    let config_content = fs::read_to_string(&config_path).ok()?;
    let meta: serde_json::Value = serde_json::from_str(&config_content).ok()?;

    let name = meta.get("name").and_then(|v| v.as_str()).unwrap_or("Unknown Instance").to_string();

    let mc_version = meta.get("manifest")
        .and_then(|m| m.get("minecraft"))
        .and_then(|mc| mc.get("version"))
        .and_then(|v| v.as_str())
        .or_else(|| meta.get("gameVersion").and_then(|v| v.as_str()))
        .or_else(|| meta.get("minecraftVersion").and_then(|v| v.as_str()))
        .unwrap_or("unknown")
        .to_string();

    let modloader = meta.get("baseModLoader")
        .and_then(|b| b.get("name"))
        .and_then(|n| n.as_str())
        .or_else(|| {
            meta.get("manifest")
                .and_then(|m| m.get("minecraft"))
                .and_then(|mc| mc.get("modLoaders"))
                .and_then(|ml| ml.get(0))
                .and_then(|ml0| ml0.get("id"))
                .and_then(|id| id.as_str())
        })
        .unwrap_or("unknown")
        .to_string();

    let mut icon_path = meta.get("customProfileImage")
        .and_then(|v| v.as_str())
        .map(|s| s.to_string());

    if icon_path.is_none() {
        icon_path = meta.get("installedModpack")
            .and_then(|im| im.get("thumbnailUrl"))
            .and_then(|v| v.as_str())
            .map(|s| s.to_string());
    }

    if icon_path.is_none() {
        let local_icon = path.join("icon.png");
        if local_icon.is_file() {
            icon_path = Some(local_icon.to_string_lossy().to_string());
        }
    }

    Some(ImportableInstance {
        name,
        mc_version,
        modloader,
        path: path.to_string_lossy().to_string(),
        icon_path,
    })
}
