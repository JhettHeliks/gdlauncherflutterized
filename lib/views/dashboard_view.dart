import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/colors.dart';
import '../../providers/dashboard_provider.dart';
import 'widgets/instance_card.dart';
import 'widgets/fade_in_up.dart';
import 'widgets/header.dart'; // To retain the top search/actions

class DashboardView extends HookConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastPlayed = ref.watch(lastPlayedProvider);
    final featuredPacks = ref.watch(featuredModpacksProvider);

    return Column(
      children: [
        // Top Search and Actions
        const LauncherHeader(),
        
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Welcome Banner
                FadeInUp(
                  delay: const Duration(milliseconds: 0),
                  child: const _DashboardHero(),
                ),
                const SizedBox(height: 48),
                
                // 2. Quick Launch Section
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jump Back In',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _QuickLaunchCard(instance: lastPlayed),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // 3. Featured Section
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Featured',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Responsive grid of featured modpacks
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: featuredPacks.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final pack = entry.value;

                          return FadeInUp(
                            delay: Duration(milliseconds: 250 + (idx * 50)),
                            child: SizedBox(
                              width: 320,
                              height: 380, // Same aspect ratio as Library instances
                              child: InstanceCard(
                                title: pack.title,
                                category: pack.category,
                                version: pack.version,
                                badgeText: pack.badgeText,
                                badgeColor: pack.badgeColor,
                                imageColors: pack.imageColors,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Private sub-widgets

class _DashboardHero extends StatelessWidget {
  const _DashboardHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.2),
            AppColors.secondaryAccent.withValues(alpha: 0.05),
            AppColors.surface,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome back, Explorer!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ready for your next adventure in the blocky universe?',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLaunchCard extends HookConsumerWidget {
  final LastPlayedInstance instance;

  const _QuickLaunchCard({required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered.value ? -4 : 0, 0)
          .scaled(isHovered.value ? 1.01 : 1.0, isHovered.value ? 1.01 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered.value
                ? AppColors.primaryAccent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            if (isHovered.value)
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
          ],
        ),
        padding: const EdgeInsets.all(32),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 32,
          runSpacing: 32,
          children: [
            // Left Side: Instance Image Placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8BA5FF), Color(0xFF6B8AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.videogame_asset, size: 48, color: Colors.white),
              ),
            ),
            
            // Middle Content: Instance Info
            Container(
              constraints: const BoxConstraints(minWidth: 180, maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Badge
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                     decoration: BoxDecoration(
                       color: AppColors.secondaryAccent.withValues(alpha: 0.15),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Container(
                           width: 6,
                           height: 6,
                           decoration: const BoxDecoration(
                             color: AppColors.secondaryAccent,
                             shape: BoxShape.circle,
                           ),
                         ),
                         const SizedBox(width: 6),
                         Flexible(
                           child: Text(
                             instance.badgeText,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(
                               color: AppColors.secondaryAccent,
                               fontWeight: FontWeight.w800,
                               fontSize: 10,
                               letterSpacing: 1.0,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 12),
                   
                   // Title
                   Text(
                     instance.title,
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style: const TextStyle(
                       color: AppColors.textPrimary,
                       fontSize: 32,
                       fontWeight: FontWeight.w900,
                       letterSpacing: -1,
                     ),
                   ),
                   const SizedBox(height: 8),
                   
                   // Details
                   Text(
                     '${instance.version} • PlayTime: ${instance.totalPlayTime} • ${instance.lastPlayedTime}',
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style: const TextStyle(
                       color: AppColors.textMuted,
                       fontSize: 14,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                ],
              ),
            ),
            
            // Right Side: Big Play Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.actionCyan, Color(0xFF00B4D8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.actionCyan.withValues(alpha: isHovered.value ? 0.6 : 0.4),
                    blurRadius: isHovered.value ? 24 : 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: AppColors.sidebarBackground, size: 36),
                      SizedBox(width: 8),
                      Text(
                        'PLAY',
                        style: TextStyle(
                          color: AppColors.sidebarBackground,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
