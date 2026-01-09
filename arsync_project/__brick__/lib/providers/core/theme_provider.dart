import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/constants.dart';
import 'shared_preferences_provider.dart';

// ignore: provider_single_per_file
final themeModeProvider = NotifierProvider.autoDispose(_ThemeModeNotifier.new);

// ignore: provider_state_class
class _ThemeModeNotifier extends Notifier<ThemeMode> {
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
