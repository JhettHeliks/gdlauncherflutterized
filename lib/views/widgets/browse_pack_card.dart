import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';

class BrowsePackCard extends HookConsumerWidget {
  final String title;
  final String version;
  final List<Color> imageGradients;

  const BrowsePackCard({
    super.key,
    required this.title,
    required this.version,
    required this.imageGradients,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isHovered.value ? -5 : 0, 0)
          .scaled(isHovered.value ? 1.02 : 1.0, isHovered.value ? 1.02 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered.value ? AppColors.primaryAccent.withValues(alpha: 0.3) : AppColors.dividerColor,
          ),
          boxShadow: isHovered.value
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Placeholder
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isHovered.value
                              ? imageGradients.map((c) => c.withValues(alpha: 0.8)).toList()
                              : imageGradients,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  
                  // Version Badge (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: isHovered.value ? 0.95 : 0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isHovered.value ? [BoxShadow(color: AppColors.background.withValues(alpha: 0.5), blurRadius: 5)] : null,
                      ),
                      child: Text(
                        version,
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            // Bottom area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isHovered.value ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.star_border, 
                    color: isHovered.value ? AppColors.premiumGold : AppColors.textSecondary, 
                    size: 20
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

