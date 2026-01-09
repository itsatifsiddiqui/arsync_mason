import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/user/app_user.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../utils/utils.dart';
import '../core/alert_provider.dart';
import '../core/router_provider.dart';
import '../core/shared_preferences_provider.dart';
import '../user/app_user_provider.dart';

final authProvider = NotifierProvider.autoDispose(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<AppUser?>> {
  @override
  AsyncValue<AppUser?> build() {
    return const AsyncValue.data(null);
  }

  Future<AppUser?> signupWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();

    try {
      final user = await ref
          .read(authRepoProvider)
          .signUpWithEmailAndPassword(name, email, password);
      if (user == null) return null;
      ref.read(appUserProvider.notifier).setUser(user);

      ref.read(routerProvider).navigateBasedAuthStatus();

      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      ref.showExceptionSheet(e);
      return null;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<AppUser?> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();

    try {
      final user = await ref
          .read(authRepoProvider)
          .signInWithEmailAndPassword(email, password);
      if (user == null) return null;
      ref.read(appUserProvider.notifier).setUser(user);

      ref.read(routerProvider).navigateBasedAuthStatus();

      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      ref.showExceptionSheet(e);
      return null;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<AppUser?> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final user = await ref.read(authRepoProvider).signInWithGoogle();
      if (user == null) return null;
      ref.read(appUserProvider.notifier).setUser(user);

      ref.read(routerProvider).navigateBasedAuthStatus();

      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      ref.showExceptionSheet(e);
      return null;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<AppUser?> signInWithApple() async {
    state = const AsyncValue.loading();

    try {
      final user = await ref.read(authRepoProvider).signInWithApple();
      if (user == null) return null;
      ref.read(appUserProvider.notifier).setUser(user);

      ref.read(routerProvider).navigateBasedAuthStatus();

      state = AsyncValue.data(user);
      return user;
    } catch (e) {
      ref.showExceptionSheet(e);
      return null;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<AppUser?> getUser() async {
    final userid = ref.read(authRepoProvider).loggedInUserId;
    if (userid == null) {
      state = const AsyncValue.data(null);
      return null;
    }
    try {
      state = const AsyncValue.loading();

      // Locally Saved User For Faster Startup time
      final savedUser = ref.read(sharedPreferencesProvider).getUser(userid);

      final user =
          savedUser ?? await ref.read(userRepoProvider).getUser(userid);
      _syncRemoteAndLocalUser(userid);

      state = AsyncValue.data(user);
      if (user == null) return null;
      return user;
    } catch (e, s) {
      // In case of error, remove user from local storage
      ref.read(sharedPreferencesProvider).removeUser(userid);
      e.toString().log('getUser error');
      state = AsyncValue.error(e, s);
      return null;
    }
  }

  void _syncRemoteAndLocalUser(String userid) async {
    try {
      final remoteUser = await ref.read(userRepoProvider).getUser(userid);
      // User is deleted from the database
      if (remoteUser == null) {
        ref.read(sharedPreferencesProvider).removeUser(userid);
        logout();
        return;
      }

      // Save user to local storage
      ref.read(sharedPreferencesProvider).saveUser(remoteUser);
      ref.read(appUserProvider.notifier).setUser(remoteUser);
    } catch (e) {
      ref.showExceptionSheet(e);
    }
  }

  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();
      final userid = ref.read(authRepoProvider).loggedInUserId;

      await ref.read(authRepoProvider).logout();
      ref.read(sharedPreferencesProvider).removeUser(userid!);
      ref.read(routerProvider).navigateBasedAuthStatus();
      state = AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      ref.showExceptionSheet(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      state = const AsyncValue.loading();
      final userid = ref.read(authRepoProvider).loggedInUserId;
      if (userid == null) throw Exception('No user is currently signed in');

      await ref.read(authRepoProvider).deleteAccount();

      // Clear local storage
      ref.read(sharedPreferencesProvider).removeUser(userid);

      // Clear app user state
      ref.read(appUserProvider.notifier).resetUser();

      // Navigate back to auth flow
      ref.read(routerProvider).navigateBasedAuthStatus();

      state = const AsyncValue.data(null);
      'Account successfully deleted for user: $userid'.log('deleteAccount');
    } catch (e, s) {
      e.toString().log('error');
      state = AsyncValue.error(e, s);
      ref.showExceptionSheet(e);
    }
  }
}
