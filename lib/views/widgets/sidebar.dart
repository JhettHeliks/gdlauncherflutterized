import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';
import '../../providers/navigation_provider.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Container(
      width: 260,
      color: AppColors.sidebarBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo Text
          const Text(
            'The Cosmic\nLauncher',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 48),

          // Nav Items
          _buildNavItem('Dashboard', Icons.grid_view, 0, selectedIndex, ref),
          const SizedBox(height: 16),
          _buildNavItem('Library', Icons.library_books, 1, selectedIndex, ref),
          const SizedBox(height: 16),
          _buildNavItem('Browse', Icons.explore, 2, selectedIndex, ref),
          const SizedBox(height: 16),
          _buildNavItem('Settings', Icons.settings, 3, selectedIndex, ref),

          const Spacer(),

          // Launch Game Button
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(27),
                onTap: () {},
                splashColor: AppColors.background.withValues(alpha: 0.1),
                highlightColor: AppColors.background.withValues(alpha: 0.05),
                child: const Center(
                  child: Text(
                    'Launch Game',
                    style: TextStyle(
                      color: AppColors.sidebarBackground, // Dark text on light button
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // User Profile Row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface, // Placeholder for image
                ),
                child: const Icon(Icons.person, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steve',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'PREMIUM MEMBER',
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Log Files
          const Row(
            children: [
              Icon(Icons.description, color: AppColors.textSecondary, size: 16),
              SizedBox(width: 8),
              Text(
                'Log Files',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index, int selectedIndex, WidgetRef ref) {
    bool isActive = selectedIndex == index;
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: isActive 
            ? null 
            : Border.all(color: AppColors.dividerColor, style: BorderStyle.solid),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(index),
          splashColor: AppColors.primaryAccent.withValues(alpha: 0.2),
          highlightColor: AppColors.primaryAccent.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.sidebarBackground : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? AppColors.sidebarBackground : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
