import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/importer.dart';

final curseForgeScannerProvider = FutureProvider<List<ImportableInstance>>((ref) async {
  return await scanCurseforgeInstances();
});
