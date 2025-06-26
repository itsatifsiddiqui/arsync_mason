import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/user/app_user.dart';

final appUserProvider = NotifierProvider<AppUserNotifier, AppUser?>(() {
  return AppUserNotifier();
});

class AppUserNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() => null; // Initial state is null, user not logged in

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
