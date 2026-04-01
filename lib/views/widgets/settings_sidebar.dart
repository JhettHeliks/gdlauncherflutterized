import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';
import '../../providers/settings_provider.dart';

class SettingsSidebar extends ConsumerWidget {
  const SettingsSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(settingsTabIndexProvider);
    return Container(
      width: 220,
      padding: const EdgeInsets.only(left: 40, right: 32, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildItem(0, 'Java', Icons.local_cafe_outlined, selectedIndex, ref),
          const SizedBox(height: 8),
          _buildItem(1, 'Mods', Icons.extension_outlined, selectedIndex, ref),
          const SizedBox(height: 8),
          _buildItem(2, 'Game', Icons.sports_esports_outlined, selectedIndex, ref),
          const SizedBox(height: 8),
          _buildItem(3, 'Arguments', Icons.description_outlined, selectedIndex, ref),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String title, IconData icon, int selectedIndex, WidgetRef ref) {
    bool isActive = selectedIndex == index;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: isActive ? Border.all(color: AppColors.dividerColor) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => ref.read(settingsTabIndexProvider.notifier).setIndex(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primaryAccent : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
