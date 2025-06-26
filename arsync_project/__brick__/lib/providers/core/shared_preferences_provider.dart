import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user/app_user.dart';
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

  // Saved User

  String userKey(String userid) => 'user_$userid';

  void saveUser(AppUser user) {
    final userString = jsonEncode(user.toJson());
    prefs.setString(userKey(user.userid), userString);
  }

  AppUser? getUser(String userid) {
    final userString = prefs.getString(userKey(userid));
    if (userString == null) return null;
    return AppUser.fromJson(jsonDecode(userString));
  }

  void removeUser(String userid) {
    prefs.remove(userKey(userid));
  }
}
