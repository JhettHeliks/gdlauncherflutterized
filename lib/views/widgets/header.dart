import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class LauncherHeader extends StatelessWidget {
  const LauncherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.sizeOf(context).width < 800;

    final searchBar = Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.searchBarBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.search, color: AppColors.primaryAccent, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search mods, servers, or playe...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile outline button
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.dividerColor,
              width: 1.5,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.person_outline, size: 20),
            color: AppColors.textPrimary,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.settings, size: 20),
          color: AppColors.textSecondary,
          onPressed: () {},
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          color: AppColors.textSecondary,
          onPressed: () {},
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 40, vertical: 24),
      child: isSmall
          ? Column(
              children: [
                searchBar,
                const SizedBox(height: 24),
                actionButtons,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: searchBar),
                const SizedBox(width: 24),
                actionButtons,
              ],
            ),
    );
  }
}
