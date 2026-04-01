---
description: This document defines the mandatory execution pipeline for any task involving code changes in the Cosmic Launcher project.
---

Phase 1: The Implementation Plan

Before writing any code, the agent must present an Implementation Plan.

Identify which Rust modules in rust/src/api/ need modification.

Identify which Riverpod Providers in lib/providers/ need updating.

List any new dependencies for Cargo.toml or pubspec.yaml.

Wait for user approval before proceeding to Phase 2.

Phase 2: Rust Backend Development

Rust is the source of truth for all heavy logic.

Implement logic in rust/src/api/.

Ensure all public functions and structs use types compatible with flutter_rust_bridge (FRB).

Use anyhow::Result for error handling to ensure clean error messages in Flutter.

Use crate::api::settings_manager::load_settings() if any file paths are required.

Phase 3: Bridge Synchronization

This is the most critical step. After any change to the Rust API:

Run the command: flutter_rust_bridge_codegen generate.

Verify that lib/src/rust/api/ and lib/src/rust/frb_generated.dart have updated.

Fix any Dart compilation errors caused by breaking changes in the Rust signatures.

Phase 4: Flutter & Riverpod Integration

State Management: Use AsyncNotifierProvider or NotifierProvider for any data coming from the bridge.

UI Reactivity: Use ref.watch() in ConsumerWidget to ensure the UI updates instantly when Rust streams progress or returns data.

Theming: Use existing Material 3 theme constants and rounded corner styles.

Phase 5: Verification & Logging

Global Logs: Inject logger.i() or logger.e() calls to track major lifecycle events.

Granular Logs: Ensure Rust writes to the local install.log for any file-intensive operations.

User Review: Ask the user to perform a Hot Restart and check the Log Reader to verify the feature.

Phase 6: Git Commitment

Once the feature is verified, help the user stage and commit the changes.

Ensure the commit message follows the feat: description or fix: description format.