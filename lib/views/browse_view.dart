import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';
import 'widgets/curated_collection.dart';
import 'widgets/browse_filter_bar.dart';
import 'widgets/browse_pack_card.dart';
import 'widgets/browse_pagination.dart';
import 'widgets/fade_in_up.dart';

class BrowseView extends HookConsumerWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsPerPage = useState(100);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.searchBarBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search modpacks, creators, or tags...',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5), width: 2),
                ),
                child: const Icon(Icons.person_outline, color: AppColors.textPrimary, size: 20),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            ],
          ),
        ),
        
        // Scroll Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CuratedCollection(),
                const SizedBox(height: 48),
                const BrowseFilterBar(),
                const SizedBox(height: 32),
                
                BrowsePaginationTop(
                  itemsPerPage: itemsPerPage.value,
                  onChanged: (val) {
                    itemsPerPage.value = val;
                  },
                ),
                const SizedBox(height: 24),
                // Results Grid
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Managed by parent scroll view
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisExtent: 260,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: 8, // Simulate 8 loading items to demonstrate grid
                    itemBuilder: (context, index) {
                      final gradients = [
                        [const Color(0xFF1E3A3A), const Color(0xFF0F1D1D)],
                        [const Color(0xFF382315), const Color(0xFF180F08)],
                        [const Color(0xFF192238), const Color(0xFF0A0E1A)],
                        [const Color(0xFF381920), const Color(0xFF15090C)],
                      ];
                      final titles = ['Wilderness', 'Clockwork Empire', 'Celestial Skies', 'Shadows of Yore'];
                      final vers = ['v1.19.2', 'v1.18.2', 'v1.20.1', 'v1.19.2'];
                      
                      return BrowsePackCard(
                        title: titles[index % titles.length],
                        version: vers[index % vers.length],
                        imageGradients: gradients[index % gradients.length],
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 48),
                const BrowsePaginationBottom(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
