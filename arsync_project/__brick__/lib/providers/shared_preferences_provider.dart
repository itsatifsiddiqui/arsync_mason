import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_provider.dart';

///Override provider in provider scope
final sharedPreferencesProvider = Provider<SharedPreferencesProvider>((ref) {
  throw UnimplementedError();
});

class SharedPreferencesProvider {
  const SharedPreferencesProvider(this.prefs, this.ref);
  final SharedPreferences prefs;
  final Ref ref;

  final onboardingKey = 'onboarding';
  final themeModeKey = 'themeMode';

  bool get showOnboarding => prefs.getBool(onboardingKey) ?? true;
  Future<void> setOnboardingFalse() async {
    await prefs.setBool(onboardingKey, false);
  }

  ThemeMode get themeMode {
    final mode = prefs.get(themeModeKey) ?? 'System';
    return kThemeModes[mode] ?? ThemeMode.system;
  }

  void setTheme(String theme) {
    prefs.setString(themeModeKey, theme);
  }
}
