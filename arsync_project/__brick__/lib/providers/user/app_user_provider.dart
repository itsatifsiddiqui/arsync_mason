import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/user/app_user.dart';
import '../core/shared_preferences_provider.dart';

final appUserProvider = NotifierProvider.autoDispose(AppUserNotifier.new);

// ignore: provider_state_class
class AppUserNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    ref.keepAlive();
    listenSelf((prev, next) {
      // Whenever user state is updated, save it to shared preferences
      if (next != null) {
        ref.read(sharedPreferencesProvider).saveUser(next);
      }
    });
    return null;
  } // Initial state is null, user not logged in

  void setUser(AppUser? user) {
    state = user;
  }

  void resetUser() => state = null;

  void markEmailAsVerified() {
    if (state != null) {
      state = state!.copyWith(isEmailVerified: true);
    }
  }

}
