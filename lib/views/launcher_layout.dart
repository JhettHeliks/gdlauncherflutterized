import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'widgets/sidebar.dart';
import 'dashboard_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import 'browse_view.dart';
import 'library_view.dart';
import 'settings_view.dart';
import 'log_reader_view.dart';

class LauncherLayout extends ConsumerWidget {
  const LauncherLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Navigation
          const Sidebar(),
          
          // Main Content Area switched based on tab with smooth animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: _buildMainContent(selectedIndex),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainContent(int selectedIndex) {
    // 0 = Dashboard, 1 = Library, 2 = Browse, 3 = Settings
    if (selectedIndex == 1) {
      return const LibraryView(key: ValueKey('library_view'));
    }
    if (selectedIndex == 2) {
      return const BrowseView(key: ValueKey('browse_view'));
    }
    if (selectedIndex == 3) {
      return const SettingsView(key: ValueKey('settings_view'));
    }
    if (selectedIndex == 4) {
      return const LogReaderView(key: ValueKey('log_reader_view'));
    }
    
    // Default to Dashboard view
    return const DashboardView(key: ValueKey('dashboard_view'));
  }
}
