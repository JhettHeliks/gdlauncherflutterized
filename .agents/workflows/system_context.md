---
description: You are an expert developer working on Cosmic Launcher, a high-performance Minecraft launcher built with a Flutter frontend and a Rust backend using flutter_rust_bridge (FRB).
---

Cosmic Launcher Project Manifesto & Context

You are an expert developer working on Cosmic Launcher, a high-performance Minecraft launcher built with a Flutter frontend and a Rust backend using flutter_rust_bridge (FRB).

🛠 Tech Stack & Architecture

Frontend: Flutter (Dart) using Material 3 Expressive.

State Management: Riverpod is the strict standard. Use ConsumerWidget, HookConsumerWidget, and NotifierProvider/AsyncNotifierProvider.

Backend: Rust handles heavy lifting (File System, Zip, Networking).

The Bridge: flutter_rust_bridge v2. Logic in rust/src/api/.

Code Generation: flutter_rust_bridge_codegen generate.

🎨 M3 Expressive Design Standards

Playful Geometry: Use large corner radii (28px to 32px) for cards, dialogs, and buttons. Avoid sharp edges.

Fluid Motion: Every interaction should have a transition. Use AnimatedContainer, AnimatedScale, and hero tags for navigation.

Tactile Feedback: * Hover: Subtle scale up (1.02x) and increased glow/elevation.

Tap: Distinct ink ripples and squash/stretch animations.

Theming: Deep navy backgrounds with vibrant, glowing neon primary accents.

📂 Structural Conventions & Core Documents

Providers: lib/providers/.

Views/Widgets: lib/views/ and lib/views/widgets/.

Instance Storage: Each modpack is isolated in its own folder under a master instance_dir managed by settings_manager.rs.

Boilerplate Reference: Consult boilerplate_reference.md for standard Riverpod and Rust Bridge skeleton code to ensure architectural consistency.

State of the App: Reference state_of_the_app.md for a running summary of completed features, current focus, and known bugs.

📜 Logging & Debugging

App Logs: Custom LogReaderView displays app_logs.txt via the logger package.

Instance Logs: Rust writes granular install.log files inside each instance directory.

⚠️ Hard Rules

Responsive First: Use Expanded, Flexible, and LayoutBuilder. No "Caution Tape" overflows allowed.

Detached Logic: Rust functions must be async and never block the Flutter UI thread.

Branding: All metadata should label the source as "Cosmic Launcher".