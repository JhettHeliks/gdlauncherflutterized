import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../src/rust/api/settings_manager.dart';

class SettingsStateNotifier extends AsyncNotifier<LauncherSettings> {
  @override
  Future<LauncherSettings> build() async {
    return await loadSettings();
  }

  Future<void> updateInstanceDirectory(String newDir) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;
    
    final updatedSettings = LauncherSettings(instanceDir: newDir);
    
    state = const AsyncValue.loading();
    try {
      await saveSettings(settings: updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e) {
      // Revert optimism if failed
      state = AsyncValue.data(currentSettings);
      throw Exception('Failed to save settings: $e');
    }
  }

  Future<void> browseForInstanceDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      await updateInstanceDirectory(result);
    }
  }
}

final settingsStateProvider = AsyncNotifierProvider<SettingsStateNotifier, LauncherSettings>(() {
  return SettingsStateNotifier();
});
