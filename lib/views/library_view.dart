import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/importer_provider.dart';
import '../providers/installation_provider.dart';
import '../theme/colors.dart';
import 'widgets/library_header.dart';
import 'widgets/library_instance_card.dart';
import 'widgets/installing_instance_card.dart';
import 'widgets/add_instance_card.dart';
import 'widgets/expandable_add_button.dart';
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

    final bodyContent = Stack(
      children: [
        // Main Grid layer
        Positioned.fill(
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

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 48), // Adjusted top padding for unified header
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
        ),
        
        // Header Text block (Solid background)
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: LibraryHeader(),
        ),

        // Action Buttons Overlay (Decoupled to prevent dropdown clipping)
        Positioned(
          top: 18.0, // 12.0 padding + 6.0 offset
          right: isSmall ? 20.0 : 40.0,
          child: const LibraryActionButtons(),
        ),

        // New Instance Expanding Action Button Overlay
        Positioned(
          bottom: 24.0,
          right: isSmall ? 20.0 : 40.0,
          child: ExpandableAddButton(isSmall: isSmall),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: bodyContent,
    );
  }
}

