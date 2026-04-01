import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/colors.dart';
import 'add_instance_dialog.dart';

class ExpandableAddButton extends HookWidget {
  final bool isSmall;
  const ExpandableAddButton({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
    );

    useEffect(() {
      if (isOpen.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isOpen.value]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Secondary Options
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
          axisAlignment: 1.0, // Expand upwards
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOut,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSecondaryOption(
                    context,
                    label: 'Create Vanilla',
                    icon: Icons.grass,
                    onTap: () {
                      isOpen.value = false;
                      showDialog(
                        context: context,
                        builder: (_) => const AddInstanceDialog(initialIndex: 0),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSecondaryOption(
                    context,
                    label: 'Import Modpack',
                    icon: Icons.folder_zip,
                    onTap: () {
                      isOpen.value = false;
                      showDialog(
                        context: context,
                        builder: (_) => const AddInstanceDialog(initialIndex: 1),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Primary Button
        FloatingActionButton.extended(
          onPressed: () => isOpen.value = !isOpen.value,
          backgroundColor: AppColors.actionCyan,
          elevation: isOpen.value ? 20 : 12,
          isExtended: !isSmall,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          icon: RotationTransition(
            turns: Tween(begin: 0.0, end: 0.125).animate(
              CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
            ),
            child: const Icon(Icons.add, color: AppColors.sidebarBackground, size: 24),
          ),
          label: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: (!isSmall)
                ? const Text(
                    'New Instance',
                    style: TextStyle(
                      color: AppColors.sidebarBackground,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    maxLines: 1,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryOption(BuildContext context, {required String label, required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: AppColors.searchBarBackground,
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: isSmall ? 16 : 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    axisAlignment: 1.0,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: isSmall
                    ? const SizedBox.shrink(key: ValueKey('empty'))
                    : Row(
                        key: const ValueKey('text'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
              ),
              Icon(icon, color: AppColors.primaryAccent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
