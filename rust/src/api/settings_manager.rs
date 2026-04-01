use serde::{Deserialize, Serialize};
use directories::ProjectDirs;
use std::fs;
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LauncherSettings {
    pub instance_dir: String,
}

pub fn load_settings() -> LauncherSettings {
    let settings_path = get_settings_file_path();
    if let Ok(content) = fs::read_to_string(&settings_path) {
        if let Ok(settings) = serde_json::from_str(&content) {
            return settings;
        }
    }
    
    // Default settings
    let default_settings = LauncherSettings {
        instance_dir: get_default_instance_dir(),
    };
    
    // Try save default
    let _ = save_settings(default_settings.clone());
    
    default_settings
}

pub fn save_settings(settings: LauncherSettings) -> anyhow::Result<()> {
    let settings_path = get_settings_file_path();
    if let Some(parent) = settings_path.parent() {
        fs::create_dir_all(parent)?;
    }
    
    let content = serde_json::to_string_pretty(&settings)?;
    fs::write(settings_path, content)?;
    Ok(())
}

fn get_base_dir() -> PathBuf {
    if let Some(proj_dirs) = ProjectDirs::from("", "", "CosmicLauncher") {
        proj_dirs.config_dir().to_path_buf()
    } else {
        // Fallback to current directory
        PathBuf::from("CosmicLauncher")
    }
}

fn get_settings_file_path() -> PathBuf {
    get_base_dir().join("settings.json")
}

fn get_default_instance_dir() -> String {
    let dir = get_base_dir().join("instances");
    dir.to_string_lossy().to_string()
}
