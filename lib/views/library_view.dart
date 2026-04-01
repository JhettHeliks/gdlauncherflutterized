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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmall = screenWidth < 800;
    
    // Smooth grid spacing scaling
    final double gridSpacing = (screenWidth * 0.025).clamp(16.0, 32.0);

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LibraryHeader(),
        Expanded(
          child: Stack(
            children: [
              Padding(
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

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 80, bottom: 48), // Increased top padding for floating buttons
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    mainAxisExtent: 380, // Taller aspect ratio as per mockup
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: gridSpacing + 8.0, // A bit extra vertical breathing space
                  ),
                  itemCount: totalCount,
                  itemBuilder: (context, index) {
                    Widget cardWidget;
                    
                    if (index < activeList.length) {
                      final activeEntry = activeList[index];
                      final prog = activeEntry.value;
                      cardWidget = InstallingInstanceCard(
                        title: activeEntry.key,
                        percentage: prog.totalFiles > 0 ? (prog.downloadedFiles / prog.totalFiles * 100).toInt() : 0,
                        currentFile: prog.currentFile,
                      );
                    } else {
                      final completedIndex = index - activeList.length;
                      if (completedIndex < completedItems.length) {
                        final item = completedItems[completedIndex];
                        cardWidget = LibraryInstanceCard(
                          title: item.name,
                          modCountText: 'Scanned Profile', // Placeholder until mod count logic is added
                          badges: [item.modloader.toUpperCase(), 'V${item.mcVersion}'],
                          lastPlayedText: 'Available locally', // Placeholder
                          imageColors: const [Color(0xFF262C31), Color(0xFF101316)], // Default mockup colors
                          iconPath: item.iconPath,
                          sourceApp: item.source.isNotEmpty ? item.source : 'Cosmic Launcher',
                        );
                      } else {
                        cardWidget = const AddInstanceCard();
                      }
                    }
                    
                    // Cascade animation based on staggered index
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 + (index * 40).clamp(0, 400)),
                      child: cardWidget,
                    );
                  },
                );
              },
            ),
              ),
              Positioned(
                top: 0,
                right: isSmall ? 20 : 40,
                left: isSmall ? 20 : null,
                child: const LibraryActionButtons(),
              ),
            ],
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

