import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/rust/api/vanilla_manager.dart';

final vanillaVersionProvider = AsyncNotifierProvider<VanillaVersionNotifier, List<String>>(() {
  return VanillaVersionNotifier();
});

class VanillaVersionNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    return await getVanillaVersions();
  }
}
