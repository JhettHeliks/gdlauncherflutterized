import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final settingsTabIndexProvider = NotifierProvider<SettingsTabIndexNotifier, int>(() {
  return SettingsTabIndexNotifier();
});
