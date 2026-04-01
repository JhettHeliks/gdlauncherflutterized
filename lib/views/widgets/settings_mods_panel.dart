import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SettingsModsPanel extends StatelessWidget {
  const SettingsModsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 40, bottom: 48),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mod Management',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.folder_open, color: AppColors.primaryAccent, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Open Mods Folder',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          
          _buildModItem('Sodium', 'Version 0.5.3 • Fabric', Icons.layers, true),
          const SizedBox(height: 16),
          _buildModItem('Iris Shaders', 'Version 1.6.9 • Complementary Shaders', Icons.landscape, true),
          const SizedBox(height: 16),
          _buildModItem('Better Foliage', 'Version 3.2.1 • Feature', Icons.eco, false),
        ],
      ),
    );
  }

  Widget _buildModItem(String title, String subtitle, IconData icon, bool enabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: enabled ? AppColors.primaryAccent.withValues(alpha: 0.2) : AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: enabled ? AppColors.primaryAccent : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          
          // Switch Custom UI
          Container(
            width: 52,
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: enabled ? AppColors.primaryAccent : AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
