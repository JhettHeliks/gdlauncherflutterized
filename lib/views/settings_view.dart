import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/settings_header.dart';
import 'widgets/settings_sidebar.dart';
import 'widgets/settings_java_panel.dart';
import 'widgets/settings_mods_panel.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SettingsHeader(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SettingsSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Scroll target logic is omitted for pure continuous scrolling mock
                      const SettingsJavaPanel(),
                      const SettingsModsPanel(),
                      // Add padding to emulate more trailing blank space
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

