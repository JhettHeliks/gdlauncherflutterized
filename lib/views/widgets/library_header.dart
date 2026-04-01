import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedButton(
            icon: Icons.refresh,
            label: 'Refresh',
            isCollapsed: isSmall,
            onTap: () => ref.invalidate(curseForgeScannerProvider),
          ),
          const SizedBox(width: 12.0),
          ExpandingFilterButton(isSmall: isSmall),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required bool isCollapsed,
    required VoidCallback onTap,
  }) {
    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 18 : 24),
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                axisAlignment: -1.0,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: isCollapsed
                ? const SizedBox.shrink(key: ValueKey('empty'))
                : Container(
                    key: const ValueKey('content'),
                    height: 56,
                    padding: const EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: content,
    );
  }
}

class ExpandingFilterButton extends HookConsumerWidget {
  final bool isSmall;
  const ExpandingFilterButton({super.key, required this.isSmall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);

    return MouseRegion(
      onEnter: (_) => isExpanded.value = true,
      onExit: (_) => isExpanded.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
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
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => isExpanded.value = !isExpanded.value,
                borderRadius: BorderRadius.circular(28),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: isSmall && !isExpanded.value ? 16 : 24),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list, color: AppColors.textPrimary, size: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1.0,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: (!isSmall || isExpanded.value)
                            ? Container(
                                key: const ValueKey('expanded-text'),
                                height: 56,
                                padding: const EdgeInsets.only(left: 12),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              )
                            : const SizedBox.shrink(key: ValueKey('collapsed')),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: isExpanded.value
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              child: Text(
                                'SORT BY',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            _buildOption('Last Played'),
                            _buildOption('Alphabetical'),
                            _buildOption('Most Played'),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
