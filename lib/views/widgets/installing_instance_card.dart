import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;
import '../../theme/colors.dart';

class InstallingInstanceCard extends HookWidget {
  final String title;
  final int percentage;
  final String currentFile;

  const InstallingInstanceCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.currentFile,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          // The strong ambient neon glow casting outwards across the whole card
          BoxShadow(
            color: AppColors.actionCyan.withValues(alpha: 0.5),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Solid base track: guarantees the border line exists everywhere just like the prototype picture
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          
          // Rotating neon sweep highlight over the solid track
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxSize = math.max(constraints.maxWidth, constraints.maxHeight) * 1.5;
                return Center(
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: animationController.value * 2 * math.pi,
                        child: Container(
                          width: maxSize,
                          height: maxSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.actionCyan.withValues(alpha: 0.0),
                                AppColors.actionCyan,
                                Colors.white,
                                AppColors.actionCyan,
                                AppColors.actionCyan.withValues(alpha: 0.0),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 0.48, 0.5, 0.52, 0.65, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          
          // The Masking solid inner card
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: AppColors.surface, // Same backing as standard instance card
              borderRadius: BorderRadius.circular(29),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background, // Deep empty state backing
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                       child: Text(
                         '$percentage%',
                         style: const TextStyle(
                           color: AppColors.textPrimary,
                           fontSize: 48,
                           fontWeight: FontWeight.w900,
                         ),
                       ),
                     ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                           color: AppColors.textPrimary,
                           fontSize: 20,
                           fontWeight: FontWeight.w900,
                           height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Downloading:\n$currentFile',
                        style: const TextStyle(
                           color: AppColors.textSecondary,
                           fontSize: 10,
                           height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                   children: [
                      Icon(Icons.info_outline, color: AppColors.textSecondary, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                         child: Text(
                           'Installing Active Engine...',
                           style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                         ),
                      ),
                   ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
