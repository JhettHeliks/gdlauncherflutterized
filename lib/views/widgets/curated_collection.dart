import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class CuratedCollection extends StatelessWidget {
  const CuratedCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top text row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curated Collections',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hand-picked experiences for every playstyle.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'View All Collections',
                  style: TextStyle(
                    color: AppColors.primaryAccent.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: AppColors.primaryAccent.withValues(alpha: 0.9), size: 16),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        
        // Asymmetric Grid
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Featured Card
              Expanded(
                flex: 5,
                child: _buildFeaturedCard(),
              ),
              const SizedBox(width: 24),
              // Right Column (2 smaller cards)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(child: _buildSmallCollectionCard('Infernal Origins', 'Hardcore Survival • 120 Mods', [const Color(0xFF3E1611), const Color(0xFF1B0705)])),
                    const SizedBox(height: 24),
                    Expanded(child: _buildSmallCollectionCard('Astro-Tech 3000', 'Automation • Space Exploration', [const Color(0xFF0F1A24), const Color(0xFF060B10)])),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const RadialGradient(
          colors: [Color(0xFF2A362B), Color(0xFF101912)],
          radius: 1.5,
          center: Alignment.topCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.premiumGold.withValues(alpha: 0.5)),
                  ),
                  child: const Text('STAFF PICK', style: TextStyle(color: AppColors.premiumGold, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ethereal Horizons: Reforged',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A magical realism journey featuring 250+ mods, custom world generation, and\na fully voiced questline. Experience Minecraft like never before.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.actionCyan, // Using existing action color
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.actionCyan.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(Icons.download, color: AppColors.sidebarBackground, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Install Modpack',
                            style: TextStyle(
                              color: AppColors.sidebarBackground,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.searchBarBackground,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmallCollectionCard(String title, String subtitle, List<Color> bgColors) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
