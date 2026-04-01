import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';
import 'add_instance_dialog.dart';

class AddInstanceCard extends HookConsumerWidget {
  const AddInstanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return const AddInstanceDialog();
            },
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isHovered.value ? -5 : 0, 0)
            .scaled(isHovered.value ? 1.02 : 1.0, isHovered.value ? 1.02 : 1.0, 1.0),
          decoration: BoxDecoration(
            color: isHovered.value ? AppColors.surface.withValues(alpha: 0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovered.value ? AppColors.primaryAccent.withValues(alpha: 0.5) : AppColors.dividerColor,
              width: 2,
            ),
            boxShadow: isHovered.value 
                ? [BoxShadow(color: AppColors.primaryAccent.withValues(alpha: 0.1), blurRadius: 15)]
                : null,
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Floating Action Plus inside Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHovered.value ? AppColors.primaryAccent : AppColors.searchBarBackground,
                  border: Border.all(
                    color: isHovered.value ? Colors.transparent : AppColors.dividerColor,
                    width: 1.5,
                  ),
                  boxShadow: isHovered.value 
                      ? [BoxShadow(color: AppColors.primaryAccent.withValues(alpha: 0.5), blurRadius: 10)]
                      : null,
                ),
                child: Icon(Icons.add, color: isHovered.value ? AppColors.background : AppColors.primaryAccent, size: 28),
              ),
              const SizedBox(height: 24),
              
              // Text Content
              const Text(
                'Add New Instance',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Import from\nCurseForge, FTB,\nor build from\nscratch.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


