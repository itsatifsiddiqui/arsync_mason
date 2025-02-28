import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/utils.dart';
import '../../../providers/alert_provider.dart';
import '../../../providers/app_user_provider.dart';
import '../../../providers/router_provider.dart';
import 'auth_base_notifier.dart';
import 'log_out_provider.dart';

final deleteAccountProvider =
    StateNotifierProvider<DeleteAccountNotifier, AsyncValue<void>>(
      (ref) => DeleteAccountNotifier(ref),
    );

class DeleteAccountNotifier extends AuthBaseNotifier<void> {
  DeleteAccountNotifier(super.ref);
  final _firestore = FirebaseFirestore.instance;

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(appUserProvider);
      if (currentUser == null) throw Exception('User not logged in');

      await Future.wait([
        auth.currentUser?.delete() ?? Future.error('No current user'),
        _firestore.collection('users').doc(currentUser.userid).delete(),
      ], eagerError: true);

      'User account deleted'.log();

      state = const AsyncValue.data(null);
      ref.read(routerProvider).navigateBasedAuthStatus();
    } catch (e, s) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        await ref.showErrorSheet(
          title: 'Sign in required',
          message: 'Please sign in again to delete your account',
        );
        await ref.read(logoutProvider.notifier).logout();
        return;
      }

      handleError(e, s);
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}
