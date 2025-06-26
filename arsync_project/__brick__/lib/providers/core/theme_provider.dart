import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'shared_preferences_provider.dart';

final kThemeModes = {
  'System': ThemeMode.system,
  'Light': ThemeMode.light,
  'Dark': ThemeMode.dark,
};

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ref.read(sharedPreferencesProvider).themeMode;
});
