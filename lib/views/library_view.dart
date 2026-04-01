import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/importer_provider.dart';
import '../providers/installation_provider.dart';
import '../theme/colors.dart';
import 'widgets/library_header.dart';
import 'widgets/library_instance_card.dart';
import 'widgets/installing_instance_card.dart';
import 'widgets/add_instance_card.dart';
import 'widgets/fade_in_up.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(curseForgeScannerProvider);
    final activeInstalls = ref.watch(installationProgressProvider);
    final activeList = activeInstalls.entries.toList();
    final isSmall = MediaQuery.sizeOf(context).width < 800;

    final bodyContent = Column(
      children: [
        const LibraryHeader(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 40),
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
                // Filter out any parsed items that are currently active in downloading state
                final completedItems = items.where((i) => !activeInstalls.containsKey(i.name)).toList();
                final totalCount = activeList.length + completedItems.length + 1; // +1 for AddInstanceCard

                return FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 48),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      mainAxisExtent: 380, // Taller aspect ratio as per mockup
                      crossAxisSpacing: isSmall ? 16 : 24,
                      mainAxisSpacing: isSmall ? 16 : 32,
                    ),
                    itemCount: totalCount,
                    itemBuilder: (context, index) {
                      if (index < activeList.length) {
                        final activeEntry = activeList[index];
                        final prog = activeEntry.value;
                        return InstallingInstanceCard(
                          title: activeEntry.key,
                          percentage: prog.totalFiles > 0 ? (prog.downloadedFiles / prog.totalFiles * 100).toInt() : 0,
                          currentFile: prog.currentFile,
                        );
                      }
                      
                      final completedIndex = index - activeList.length;
                      if (completedIndex < completedItems.length) {
                        final item = completedItems[completedIndex];
                        return LibraryInstanceCard(
                          title: item.name,
                          modCountText: 'Scanned Profile', // Placeholder until mod count logic is added
                          badges: [item.modloader.toUpperCase(), 'V${item.mcVersion}'],
                          lastPlayedText: 'Available locally', // Placeholder
                          imageColors: const [Color(0xFF262C31), Color(0xFF101316)], // Default mockup colors
                          iconPath: item.iconPath,
                          sourceApp: item.source.isNotEmpty ? item.source : 'Cosmic Launcher',
                        );
                      }
                      
                      return const AddInstanceCard();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open Add Instance dialog or workflow
        },
        backgroundColor: AppColors.actionCyan,
        elevation: 12,
        icon: const Icon(Icons.add, color: AppColors.sidebarBackground, size: 22),
        label: const Text(
          'New Instance',
          style: TextStyle(
            color: AppColors.sidebarBackground,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            height: 1.0,
          ),
        ),
      ),
      body: bodyContent,
    );
  }
}

