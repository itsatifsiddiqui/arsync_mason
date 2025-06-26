import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/app_user.dart';
import '../providers/core/shared_preferences_provider.dart';
import 'storage_repository.dart';
import 'user_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    storageRepo: ref.read(storageRepoProvider),
    sharedPreferences: ref.read(sharedPreferencesProvider).prefs,
    userRepository: ref.read(userRepositoryProvider),
  );
});

class AuthRepository {
  final StorageRepository storageRepo;
  final SharedPreferences sharedPreferences;
  final UserRepository userRepository;

  AuthRepository({
    required this.storageRepo,
    required this.sharedPreferences,
    required this.userRepository,
  });

  String? get loggedInUserId => sharedPreferences.getString('userid');

  Future<AppUser?> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final userid = UniqueKey().toString();

    final user = AppUser(
      userid: userid,
      name: name,
      email: email,
      isActive: true,
    );

    final createdUser = await userRepository.createUser(user);

    sharedPreferences.setString('userid', userid);

    return createdUser;
  }

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await userRepository.getUserByEmail(email);

    if (user == null) throw Exception('User not found');

    sharedPreferences.setString('userid', user.userid);

    return user;
  }

  Future<AppUser?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = AppUser(
      userid: 'userid',
      name: 'Google',
      email: 'google@gmail.com',
      isActive: true,
    );

    final createdUser = await userRepository.createUser(user);

    return createdUser;
  }

  Future<AppUser?> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = AppUser(
      userid: 'userid',
      name: 'Apple',
      email: 'apple@gmail.com',
      isActive: true,
    );

    final createdUser = await userRepository.createUser(user);

    return createdUser;
  }

  Future<void> logout() async {
    await sharedPreferences.remove('userid');
  }

  Future<void> deleteAccount() async {
    final userid = sharedPreferences.getString('userid');
    if (userid == null) throw Exception('No user is currently signed in');
    await userRepository.deleteUser(userid);
    logout();
  }
}
