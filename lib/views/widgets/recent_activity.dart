import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View Log History',
                style: TextStyle(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        
        // List
        _buildActivityItem(
          icon: Icons.refresh,
          title: 'Auto-Update Completed',
          subtitle: "Applied 3 patches to 'Skyblock Adventures'",
          time: '2m ago',
          iconColor: AppColors.textPrimary,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.cloud_done_outlined,
          title: 'World Sync Finished',
          subtitle: "'My Survival World' successfully uploaded to cloud",
          time: '1h ago',
          iconColor: const Color(0xFFF06584), // Reddish icon matching the mockup
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.videogame_asset_outlined,
          title: 'Session Recorded',
          subtitle: "Played 'Ethereal Realm' for 4 hours 12 minutes",
          time: 'Yesterday',
          iconColor: AppColors.secondaryAccent,
          isActive: true, // Glow effect
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color iconColor,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: AppColors.secondaryAccent.withValues(alpha: 0.5), width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.secondaryAccent.withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.secondaryAccent.withValues(alpha: 0.15) : AppColors.dividerColor,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Time
          Text(
            time,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
