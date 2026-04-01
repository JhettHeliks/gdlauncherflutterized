---
description: You are an expert developer working on Cosmic Launcher, a high-performance Minecraft launcher built with a Flutter frontend and a Rust backend using flutter_rust_bridge (FRB).
---

🛠 Tech Stack & Architecture

Frontend: Flutter (Dart) using Material 3.

State Management: Riverpod is the strict standard. Use ConsumerWidget, HookConsumerWidget, and NotifierProvider/AsyncNotifierProvider. Avoid setState for global logic.

Backend: Rust handles all heavy lifting (File System, Zip extraction, Networking).

The Bridge: flutter_rust_bridge v2. Rust logic lives in rust/src/api/.

Code Generation: Trigger updates using flutter_rust_bridge_codegen generate.

📂 Structural Conventions

Providers: Located in lib/providers/.

Views: Located in lib/views/.

Widgets: Located in lib/views/widgets/.

Instance Storage: Controlled by a global settings_manager.rs. Each modpack is isolated in its own folder under a master instance_dir.

Metadata: Every instance contains a cosmic_instance.json file for local discovery.

📜 Logging & Debugging Standards

App Logs: Use the logger package. A custom LogReaderView exists to display app_logs.txt.

Instance Logs: Every installation must create an isolated install.log inside the instance folder (managed by Rust) to record granular file-by-file progress.

Progress: Real-time installation progress is handled via a StreamSink in Rust, pushed to an installationProgressProvider in Dart.

🚀 Key Features Implemented

CurseForge Scanner: Scans local paths for existing modpacks using directories crate.

Archive Analyzer: Peeks inside .zip and .mrpack files without full extraction.

Zip Extractor: Handles overrides extraction and manifest.json parsing.

Concurrent Downloader: Uses reqwest and tokio to fetch .jar files using CurseForge API IDs.

Settings Manager: Manages global app configuration and persistent library paths.

⚠️ Hard Rules

NEVER use alert() or confirm(). Use Material 3 Dialogs or Snackerbars.

ALWAYS await the flutter_rust_bridge_codegen process after modifying Rust API files.

ALWAYS check for the isAuthReady state when interacting with persistent data.

UI Consistency: Follow the "Cosmic Launcher" dark theme (Deep navys, primary accents, rounded corners).