import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/archive_provider.dart';
import '../../src/rust/api/archive_parser.dart';
import '../../src/rust/api/importer_pipeline.dart';
import '../../src/rust/api/downloader.dart';
import '../../src/rust/api/downloader.dart';
import '../../theme/colors.dart';
import '../../providers/log_provider.dart';
import '../../providers/installation_provider.dart';

class ImportDialog extends HookConsumerWidget {
  final String zipPath;

  const ImportDialog({super.key, required this.zipPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveMetadataAsync = ref.watch(modpackArchiveAnalyzerProvider(zipPath));
    final isImporting = useState(false);

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
          onPressed: isImporting.value ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          // Only enable if we have successfully parsed the data and aren't currently importing
          onPressed: archiveMetadataAsync.hasValue && !isImporting.value
              ? () async {
                  final metadata = metadataFromAsync(archiveMetadataAsync);
                  if (metadata == null) return;
                  
                  isImporting.value = true;
                  debugPrint('Import started for ${metadata.name}');
                  appLogger.i('Import started for ${metadata.name}');
                  
                  try {
                    // Show a simple loading snackbar
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Extracting & Downloading ${metadata.name}...')),
                      );
                    }
                    
                    final extractResult = await extractCurseforgeZip(
                      zipPath: zipPath,
                    );
                    
                    final instancePath = extractResult.$1;
                    final fileIds = extractResult.$2;
                    
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    
                    ref.read(installationProgressProvider.notifier).startInstallation(
                      metadata.name,
                      instancePath,
                      fileIds,
                      r'$2a$10$T6FGRH9NF8E7uJbiCbEPWONrUEe5u/RsoxqSkx9E1WikxgjqEMQg6',
                    );
                    
                  } catch (e) {
                    appLogger.e('Zip Extractor failed a file system operation: $e');
                    debugPrint('Extraction failed: $e');
                    isImporting.value = false;
                  }
                }
              : null,
          child: isImporting.value 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Confirm Import'),
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
