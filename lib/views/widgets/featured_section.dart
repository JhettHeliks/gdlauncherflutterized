import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'instance_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

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
              'Featured',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                _buildNavButton(Icons.chevron_left),
                const SizedBox(width: 8),
                _buildNavButton(Icons.chevron_right),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        
        // Cards Row
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: InstanceCard(
                  title: 'Shadow of Zenith',
                  category: 'RPG',
                  version: '1.19.2',
                  badgeText: 'NEW',
                  imageColors: const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: InstanceCard(
                  title: 'Cyber-Block 2077',
                  category: 'TECH',
                  version: '1.20.1',
                  badgeText: 'HOT',
                  badgeColor: Color(0xFFE84C3D), // Reddish
                  imageColors: [Color(0xFF141E30), Color(0xFF243B55)],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNavButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 20),
    );
  }
}
