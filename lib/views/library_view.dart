import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/importer_provider.dart';
import '../theme/colors.dart';
import 'widgets/library_header.dart';
import 'widgets/library_instance_card.dart';
import 'widgets/add_instance_card.dart';
import 'widgets/fade_in_up.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(curseForgeScannerProvider);

    return Column(
      children: [
        const LibraryHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: instancesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading instances: $err',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              data: (items) {
                return FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 48),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      mainAxisExtent: 380, // Taller aspect ratio as per mockup
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 32,
                    ),
                    itemCount: items.length + 1, // +1 for the empty Add state
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return const AddInstanceCard();
                      }
                      
                      final item = items[index];
                      return LibraryInstanceCard(
                        title: item.name,
                        modCountText: 'Scanned Profile', // Placeholder until mod count logic is added
                        badges: [item.modloader.toUpperCase(), 'V${item.mcVersion}'],
                        lastPlayedText: 'Available locally', // Placeholder
                        imageColors: const [Color(0xFF262C31), Color(0xFF101316)], // Default mockup colors
                        iconPath: item.iconPath,
                        sourceApp: 'CurseForge App',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

