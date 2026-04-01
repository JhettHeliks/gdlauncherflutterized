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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: isSmallScreen
              ? Builder(
                  builder: (context) => FloatingActionButton(
                    backgroundColor: AppColors.searchBarBackground,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: const Icon(Icons.menu, color: AppColors.textPrimary),
                  ),
                )
              : null,
          drawer: isSmallScreen
              ? Theme(
                  data: Theme.of(context).copyWith(
                    drawerTheme: const DrawerThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
                      ),
                      backgroundColor: AppColors.sidebarBackground,
                      elevation: 16,
                    ),
                  ),
                  child: const Drawer(
                    child: Sidebar(),
                  ),
                )
              : null,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Navigation with M3 Fluid Fold Animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1.0, // Anchors to the left edge
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: isSmallScreen ? const SizedBox.shrink() : const Sidebar(),
              ),
              
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
      },
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
