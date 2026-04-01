import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/downloader.dart';
import 'log_provider.dart';

final installationProgressProvider = NotifierProvider<InstallationProgressNotifier, Map<String, DownloadProgress>>(() {
  return InstallationProgressNotifier();
});

class InstallationProgressNotifier extends Notifier<Map<String, DownloadProgress>> {
  @override
  Map<String, DownloadProgress> build() {
    return {};
  }

  Future<void> startInstallation(String instanceName, String instancePath, List<int> fileIds, String apiKey) async {
    appLogger.i('[$instanceName] Starting background modpack downloader for ${fileIds.length} files...');
    
    // Initial UI state
    state = {
      ...state,
      instanceName: DownloadProgress(
        totalFiles: fileIds.length,
        downloadedFiles: 0,
        currentFile: 'Initializing Download Engine...',
      )
    };
    
    try {
      final stream = downloadCurseforgeMods(
        instancePath: instancePath,
        fileIds: fileIds,
        apiKey: apiKey,
      );

      int nextLogCheckpoint = 25; 

      await for (final progress in stream) {
        state = {
          ...state,
          instanceName: progress,
        };
        
        if (progress.totalFiles > 0) {
          final percentage = (progress.downloadedFiles / progress.totalFiles * 100).toInt();
          if (percentage >= nextLogCheckpoint) {
             appLogger.i('[$instanceName] Setup at $percentage%');
             nextLogCheckpoint += 25;
          }
        }
      }
      
      appLogger.i('[$instanceName] Successfully completed modpack installation!');
      await exportAppLogsTo(instancePath);
      
      Future.delayed(const Duration(seconds: 2), () {
        final newState = Map<String, DownloadProgress>.from(state);
        newState.remove(instanceName);
        state = newState;
      });
      
    } catch (e) {
      appLogger.e('[$instanceName] Installation failed: $e');
      final newState = Map<String, DownloadProgress>.from(state);
      newState.remove(instanceName);
      state = newState;
    }
  }
}
