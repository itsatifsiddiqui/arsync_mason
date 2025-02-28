import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/app_user.dart';

final appUserProvider = StateNotifierProvider<AppUserProvider, AppUser?>(
  (ref) => AppUserProvider(ref),
);

class AppUserProvider extends StateNotifier<AppUser?> {
  final Ref ref;
  AppUserProvider(this.ref) : super(null) {
    //Whenever State is updated. this listener is called
    addListener((state) {});
  }

  void overrideUser(AppUser? user) => state = user;

  void resetUser() => state = null;

  void markEmailAsVerified() {
    state = state?.copyWith(isEmailVerified: true);
  }
}
