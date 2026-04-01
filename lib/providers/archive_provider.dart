import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/archive_parser.dart';

// Provider to analyze an archive given its string file path
final modpackArchiveAnalyzerProvider = FutureProvider.autoDispose.family<ParsedArchiveMetadata, String>((ref, zipPath) async {
  return await analyzeModpackArchive(zipPath: zipPath);
});
