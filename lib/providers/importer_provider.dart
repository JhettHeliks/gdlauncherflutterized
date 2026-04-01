import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/importer.dart';
import 'log_provider.dart';

final curseForgeScannerProvider = FutureProvider<List<ImportableInstance>>((ref) async {
  appLogger.i('Scanning local system for CurseForge instances...');
  try {
    final instances = await scanCurseforgeInstances();
    appLogger.i('CurseForge local scanner successfully parsed directory. Found ${instances.length} instances.');
    return instances;
  } catch (e) {
    appLogger.e('Failed file system operation during CurseForge scanner: $e');
    rethrow;
  }
});
