import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';

class LibraryInstanceCard extends HookConsumerWidget {
  final String title;
  final String modCountText;
  final String lastPlayedText;
  final List<String> badges;
  final List<Color> imageColors;
  final String? iconPath;
  final String? sourceApp;

  const LibraryInstanceCard({
    super.key,
    required this.title,
    required this.modCountText,
    required this.lastPlayedText,
    required this.badges,
    required this.imageColors,
    this.iconPath,
    this.sourceApp,
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
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered.value ? AppColors.primaryAccent.withValues(alpha: 0.3) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isHovered.value 
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Internal Rounded Image Area
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Actual image or Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: iconPath != null
                        ? (iconPath!.startsWith('http')
                            ? Image.network(
                                iconPath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              )
                            : Image.file(
                                File(iconPath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              ))
                        : _buildPlaceholder(),
                  ),

                  // Image Overlay Shadow for text readability (badges)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.sidebarBackground.withValues(alpha: 0.8),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),

                  // Badges
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: badges.map((badgeText) => _buildBadge(badgeText, isHovered.value)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Middle Information Row (Title, Subtitle & Play Button)
            Row(
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
                        modCountText,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Play Button
                AnimatedScale(
                  scale: isHovered.value ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryAccent,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: isHovered.value ? 0.6 : 0.2),
                          blurRadius: isHovered.value ? 20 : 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.sidebarBackground,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Spacer(),
            
            // Footer Action Row
            Row(
              children: [
                Icon(Icons.computer, color: isHovered.value ? AppColors.textPrimary : AppColors.textSecondary, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        lastPlayedText,
                        style: TextStyle(
                          color: isHovered.value ? AppColors.textPrimary : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (sourceApp != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            sourceApp!,
                            style: TextStyle(
                              color: isHovered.value ? AppColors.textPrimary : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          colors: imageColors,
          center: Alignment.center,
          radius: 1.2,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white24,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, bool isHovered) {
    bool isVersion = text.startsWith('V1.');
    Color badgeColor = isVersion ? AppColors.actionCyan : AppColors.sidebarBackground;
    Color textColor = isVersion ? AppColors.sidebarBackground : AppColors.textPrimary;
    
    // Some logic to colorize specific texts simply
    if (text == 'FABRIC') badgeColor = AppColors.textMuted;
    if (text == 'FORGE') badgeColor = const Color(0xFF6B7280);
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVersion ? AppColors.actionCyan : Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: isHovered && isVersion
            ? [BoxShadow(color: AppColors.actionCyan.withValues(alpha: 0.4), blurRadius: 8)]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
