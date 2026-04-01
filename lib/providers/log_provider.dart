import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final _logEventsProvider = NotifierProvider<LogEventNotifier, List<String>>(() {
  return LogEventNotifier();
});

class LogEventNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void addLog(String log) {
    state = [...state, log];
  }
}

// Global hook to UI logs
final logContentProvider = Provider<List<String>>((ref) {
  return ref.watch(_logEventsProvider);
});

// A custom output that delegates to console, file, and our Notifier
class AppLogOutput extends LogOutput {
  final File file;
  final IOSink fileSink;
  final ProviderContainer container;

  AppLogOutput(this.file, this.container) : fileSink = file.openWrite(mode: FileMode.append);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      if (kDebugMode) {
        debugPrint(line);
      }
      fileSink.writeln(line);
      container.read(_logEventsProvider.notifier).addLog(line);
    }
  }

  @override
  Future<void> destroy() async {
    await fileSink.close();
  }
}


late ProviderContainer globalProviderContainer;
late Logger appLogger;
late File appLogFile;

Future<void> initLogging(ProviderContainer container) async {
  globalProviderContainer = container;
  final docs = await getApplicationDocumentsDirectory();
  final logDir = Directory('${docs.path}\\CosmicLauncher\\logs');
  if (!await logDir.exists()) {
    await logDir.create(recursive: true);
  }
  
  final now = DateTime.now();
  final timestamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
  appLogFile = File('${logDir.path}\\app_logs_$timestamp.txt');
  
  // Clean up old log files, keeping only the 10 most recent
  try {
    final files = logDir.listSync().whereType<File>().where((f) => f.path.contains('app_logs_')).toList();
    if (files.length > 10) {
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync())); // Newest first
      for (var file in files.skip(10)) {
        file.deleteSync();
      }
    }
  } catch (e) {
    debugPrint('Failed to clean old logs: $e');
  }
  
  // Create an initial separator
  appLogFile.writeAsStringSync('\n\n--- App Starting at $now ---\n\n', mode: FileMode.append);

  appLogger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: AppLogOutput(appLogFile, container),
  );
}

Future<void> exportAppLogsTo(String directoryPath) async {
  try {
    final destDir = Directory(directoryPath);
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }
    // Flush the printer output if applicable, though fileSink writes immediately
    await appLogFile.copy('${destDir.path}\\import_log.txt');
    appLogger.i('Logs exported to \\import_log.txt in the modpack directory');
  } catch (e) {
    debugPrint('Failed to export logs: $e');
  }
}

