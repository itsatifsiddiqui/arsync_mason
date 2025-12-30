import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'shared_preferences_provider.dart';

final kThemeModes = {
  'System': ThemeMode.system,
  'Light': ThemeMode.light,
  'Dark': ThemeMode.dark,
};

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ref.read(sharedPreferencesProvider).themeMode;
  }

  void setThemeMode(ThemeMode mode) {
    final key = kThemeModes.entries
        .firstWhere((entry) => entry.value == mode)
        .key;
    ref.read(sharedPreferencesProvider).setTheme(key);
    state = mode;
  }
}
