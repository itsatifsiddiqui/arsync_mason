{{#login_with_google}}
import 'package:google_sign_in/google_sign_in.dart';
{{/login_with_google}}
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/utils.dart';
import '../../../providers/router_provider.dart';
import 'auth_base_notifier.dart';

final logoutProvider = StateNotifierProvider<LogOutNotifier, AsyncValue<void>>(
  (ref) => LogOutNotifier(ref),
);

class LogOutNotifier extends AuthBaseNotifier<void> {
  LogOutNotifier(super.ref);

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      'Starting logout process'.log();

      // Sign out from Google if it was used
      {{#login_with_google}}
      await GoogleSignIn().signOut();
      'Signed out from Google'.log();
      {{/login_with_google}}
      // Sign out from Firebase
      await auth.signOut();
      'Signed out from Firebase'.log();

      ref.read(routerProvider).navigateBasedAuthStatus();
      state = const AsyncValue.data(null);
    } catch (e, s) {
      handleError(e, s);
    }
  }
}
