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

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Bottom glowing rotating layer
          LayoutBuilder(
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
                          boxShadow: [
                             BoxShadow(
                               color: AppColors.primaryAccent.withValues(alpha: 0.8),
                               blurRadius: 20,
                               spreadRadius: 10,
                             )
                          ],
                          gradient: SweepGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primaryAccent.withValues(alpha: 0.0),
                              AppColors.primaryAccent,
                              Colors.white,
                              AppColors.primaryAccent,
                              AppColors.primaryAccent.withValues(alpha: 0.0),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 0.49, 0.5, 0.51, 0.55, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Top solid layer allowing edge glow via margin
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                       child: Text(
                         '$percentage%',
                         style: const TextStyle(
                           color: AppColors.primaryAccent,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
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
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                   children: [
                      Icon(Icons.downloading, color: AppColors.primaryAccent, size: 16),
                      SizedBox(width: 6),
                      Expanded(
                         child: Text(
                           'Installing Active Engine...',
                           style: TextStyle(color: AppColors.primaryAccent, fontSize: 12, fontWeight: FontWeight.bold),
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
