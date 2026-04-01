import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';

class BrowseFilterBar extends HookConsumerWidget {
  const BrowseFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ['All Packs', 'Adventure', 'Tech & Industry', 'Magic', 'Skyblock', 'RPG', 'Vanilla+'];
    final activeIndex = useState(0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.asMap().entries.map((entry) {
          int idx = entry.key;
          String label = entry.value;
          bool isActive = idx == activeIndex.value;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => activeIndex.value = idx,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryAccent : AppColors.searchBarBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? AppColors.sidebarBackground : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

