import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/importer.dart';
import 'log_provider.dart';

final curseForgeScannerProvider = FutureProvider<List<ImportableInstance>>((ref) async {
  Future.microtask(() => appLogger.i('Scanning local system for CurseForge instances...'));
  try {
    final instances = await scanCurseforgeInstances();
    Future.microtask(() => appLogger.i('CurseForge local scanner successfully parsed directory. Found ${instances.length} instances.'));
    return instances;
  } catch (e) {
    Future.microtask(() => appLogger.e('Failed file system operation during CurseForge scanner: $e'));
    rethrow;
  }
});
