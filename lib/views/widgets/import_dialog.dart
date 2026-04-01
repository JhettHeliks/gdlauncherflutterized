import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/archive_provider.dart';
import '../../src/rust/api/archive_parser.dart';
import '../../src/rust/api/importer_pipeline.dart';
import '../../theme/colors.dart';

class ImportDialog extends ConsumerWidget {
  final String zipPath;

  const ImportDialog({super.key, required this.zipPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveMetadataAsync = ref.watch(modpackArchiveAnalyzerProvider(zipPath));

    return AlertDialog(
      title: const Text('Import Modpack'),
      content: SizedBox(
        width: 400,
        child: archiveMetadataAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing archive...'),
              ],
            ),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error analyzing archive:\n$error',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
          data: (metadata) => _buildMetadataView(metadata),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          // Only enable if we have successfully parsed the data
          onPressed: archiveMetadataAsync.hasValue
              ? () async {
                  final metadata = metadataFromAsync(archiveMetadataAsync);
                  if (metadata == null) return;
                  
                  debugPrint('Import started for ${metadata.name}');
                  
                  try {
                    final docsDir = await getApplicationDocumentsDirectory();
                    // Cleanse the name to make a safe folder path
                    final safeName = metadata.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
                    final destFolder = Directory('${docsDir.path}\\GDLauncherInstances\\$safeName');
                    
                    if (!await destFolder.exists()) {
                      await destFolder.create(recursive: true);
                    }
                    
                    // Show a simple loading snackbar
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Extracting ${metadata.name}...')),
                      );
                      Navigator.of(context).pop(); // Close dialog early while extracting
                    }
                    
                    final fileIds = await extractCurseforgeZip(
                      zipPath: zipPath, 
                      destinationFolder: destFolder.path
                    );
                    
                    debugPrint('Successfully extracted override files. Download these file_ids: $fileIds');
                    
                  } catch (e) {
                    debugPrint('Extraction failed: $e');
                  }
                }
              : null,
          child: const Text('Confirm Import'),
        ),
      ],
    );
  }

  ParsedArchiveMetadata? metadataFromAsync(AsyncValue<ParsedArchiveMetadata> asyncVal) {
    return asyncVal.whenOrNull(data: (d) => d);
  }

  Widget _buildMetadataView(ParsedArchiveMetadata metadata) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Name', metadata.name),
        const SizedBox(height: 8),
        _buildInfoRow('Version', metadata.version),
        const SizedBox(height: 8),
        _buildInfoRow('Type', metadata.archiveType.name),
        const SizedBox(height: 8),
        _buildInfoRow('Modloader', metadata.modloader),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
