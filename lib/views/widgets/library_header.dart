import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/importer_provider.dart';
import '../../theme/colors.dart';

class LibraryHeader extends ConsumerWidget {
  const LibraryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSmall = MediaQuery.sizeOf(context).width < 800;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 40, vertical: isSmall ? 12.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Instance Library',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isSmall ? 28.0 : 42.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          if (!isSmall) ...[
            const SizedBox(height: 12),
            const Text(
              'Manage your custom modpacks and vanilla installations in\none weightless environment.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LibraryActionButtons extends ConsumerWidget {
  const LibraryActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSmall = MediaQuery.sizeOf(context).width < 800;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSmall 
              ? _buildIconButton(Icons.refresh, onTap: () => ref.invalidate(curseForgeScannerProvider))
              : _buildDarkButton(Icons.refresh, 'Refresh', onTap: () {
                  ref.invalidate(curseForgeScannerProvider);
                }),
          const SizedBox(width: 12.0),
          PopupMenuButton<String>(
            color: AppColors.surface,
            elevation: 24,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            offset: const Offset(0, 56),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('All Packs', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'adventure', child: Text('Adventure', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'tech', child: Text('Tech', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'magic', child: Text('Magic', style: TextStyle(color: AppColors.textPrimary))),
            ],
            child: isSmall ? _buildIconButton(Icons.filter_list) : _buildDarkButton(Icons.filter_list, 'Filter'),
          ),
          const SizedBox(width: 12.0),
          PopupMenuButton<String>(
            color: AppColors.surface,
            elevation: 24,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            offset: const Offset(0, 56),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'latest', child: Text('Latest Played', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'alpha', child: Text('Alphabetical', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: 'most', child: Text('Most Played', style: TextStyle(color: AppColors.textPrimary))),
            ],
            child: isSmall ? _buildIconButton(Icons.sort) : _buildDarkButton(Icons.sort, 'Latest\nPlayed', isTwoLines: true),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    Widget content = Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: AppColors.searchBarBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 24),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: content,
      );
    }
    return content;
  }

  Widget _buildDarkButton(IconData icon, String label, {bool isTwoLines = false, VoidCallback? onTap}) {
    Widget content = Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.searchBarBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: content,
      );
    }
    return content;
  }
}
