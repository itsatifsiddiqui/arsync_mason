import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/app_user.dart';
import '../providers/core/shared_preferences_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final sharedPreferences = ref.read(sharedPreferencesProvider).prefs;
  return UserRepository(sharedPreferences);
});

class UserRepository {
  final SharedPreferences sharedPreferences;

  UserRepository(this.sharedPreferences);

  Future<AppUser?> getUser(String userid) async {
    final userString = sharedPreferences.getString(userid);
    if (userString == null) throw Exception('User not found');
    final userJson = jsonDecode(userString);
    final user = AppUser.fromJson(userJson);
    return user;
  }

  Future<AppUser?> getUserByEmail(String email) async {
    final userId = sharedPreferences.getString(email);
    if (userId == null) throw Exception('User not found');
    final user = await getUser(userId);
    return user;
  }

  Future<AppUser> createUser(AppUser user) async {
    final userid = user.userid;
    final userString = jsonEncode(user.toJson());
    await sharedPreferences.setString(userid, userString);
    await sharedPreferences.setString(user.email, userid);
    return user;
  }

  Future<AppUser> updateUser(AppUser user) async {
    final userString = jsonEncode(user.toJson());
    await sharedPreferences.setString(user.email, userString);
    return user;
  }

  Future<void> deleteUser(String userid) async {
    await sharedPreferences.remove(userid);
  }
}
