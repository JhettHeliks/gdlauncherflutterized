import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Data Models ---

class LastPlayedInstance {
  final String title;
  final String version;
  final String lastPlayedTime;
  final String totalPlayTime;
  final String badgeText;

  const LastPlayedInstance({
    required this.title,
    required this.version,
    required this.lastPlayedTime,
    required this.totalPlayTime,
    required this.badgeText,
  });
}

class FeaturedModpack {
  final String title;
  final String category;
  final String version;
  final String badgeText;
  final Color badgeColor;
  final List<Color> imageColors;

  const FeaturedModpack({
    required this.title,
    required this.category,
    required this.version,
    required this.badgeText,
    required this.badgeColor,
    required this.imageColors,
  });
}

// --- Providers ---

final lastPlayedProvider = Provider<LastPlayedInstance>((ref) {
  // Mocking the "Jump Back In" last played instance
  return const LastPlayedInstance(
    title: 'Ethereal Realm v2.4',
    version: '1.20.1 - Forge',
    lastPlayedTime: '2 hours ago',
    totalPlayTime: '124 hours',
    badgeText: 'CURRENTLY ACTIVE',
  );
});

final featuredModpacksProvider = Provider<List<FeaturedModpack>>((ref) {
  // Mocking 3 featured modpacks
  return const [
    FeaturedModpack(
      title: 'Shadow of Zenith',
      category: 'RPG',
      version: '1.19.2',
      badgeText: 'NEW',
      badgeColor: Color(0xFF00E5FF),
      imageColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    ),
    FeaturedModpack(
      title: 'Cyber-Block 2077',
      category: 'TECH',
      version: '1.20.1',
      badgeText: 'HOT',
      badgeColor: Color(0xFFE84C3D),
      imageColors: [Color(0xFF141E30), Color(0xFF243B55)],
    ),
    FeaturedModpack(
      title: 'Cozy Cottagecore',
      category: 'RELAX',
      version: '1.21',
      badgeText: 'STAFF PICK',
      badgeColor: Color(0xFFE8B923),
      imageColors: [Color(0xFF556270), Color(0xFFFF6B6B)],
    ),
  ];
});
