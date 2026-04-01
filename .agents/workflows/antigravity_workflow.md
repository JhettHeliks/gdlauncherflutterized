---
description: This document defines the mandatory execution pipeline for any task involving code changes in the Cosmic Launcher project.
---

Antigravity Universal Workflow: Cosmic Launcher

Follow this mandatory execution pipeline for all Cosmic Launcher tasks.

Phase 1: The Implementation Plan

Review state_of_the_app.md to understand the current project status.

Identify Rust modules (rust/src/api/) and Riverpod Providers (lib/providers/) for modification.

Consult boilerplate_reference.md for standardized code structures.

Design Check: Detail how the feature will utilize M3 Expressive motion and shapes.

Wait for user approval.

Phase 2: Rust Backend Development

Implement logic in rust/src/api/. Use anyhow::Result for errors.

Ensure any file paths utilize the global settings_manager context.

Phase 3: Bridge Synchronization

Run flutter_rust_bridge_codegen generate.

Fix Dart compilation errors caused by Rust signature changes.

Phase 4: Flutter & M3 Expressive Integration

State Management: Remember that we are strictly using Riverpod. Use AsyncNotifierProvider or NotifierProvider for bridge data. Do not use standard state management.

UI: Implement interactive states (Hover/Tap). Ensure every new component uses the large 32px rounded corners and fluid animations defined in system_context.md.

Primary Actions: Use FloatingActionButton.extended for the main action on any screen. This keeps headers clean and makes the app feel intuitive.

Responsiveness: Prefer reflowing layouts using Wrap or Column stacking on small screens. Avoid mathematically scaling text down with FittedBox so the application remains completely readable at all window sizes.

Phase 5: Verification, Autonomous Testing & Logging

Preflight Checks: Always run cargo check to verify Rust code, followed by dart analyze and flutter analyze to catch UI errors. Fix any surfaced issues immediately.

Autonomous Build Test: Execute flutter run -d windows (or flutter build windows to verify compilation).

Self-Correction Loop: If the build fails, you MUST read the terminal output, identify the compilation error (Rust or Dart), apply the fix, and re-run the build command. Do NOT ask the user for help with standard syntax or compilation errors.

Inject logger calls for major events.

Ensure Rust handles detailed logging for file heavy tasks.

User Verification: Only after a successful autonomous build, ask the user to verify visual changes, layout responsiveness (resize tests), and runtime behavior.

Phase 6: Documentation & Git Commitment

Update state_of_the_app.md with the newly completed feature and any new known bugs.

Stage and commit with clear feat: or fix: messages.

🐛 Formalized Debugging Prompt Format

When facing complex runtime crashes or logic errors that the autonomous loop cannot solve, the user will use this exact format. Do not act without these logs:

Task: Debug [Feature/Issue Name]
Flutter Error: [Paste Flutter console output]
Rust Log: [Paste relevant Rust log output]
App Log: [Paste app_logs.txt output]