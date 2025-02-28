import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/app_user.dart';
import '../../../utils/logging_extensions.dart';
import '../../../providers/alert_provider.dart';
import '../firebase_messaging_provider.dart';
import '../firestore_provider.dart';
import '../../../providers/router_provider.dart';

/// Base class for all authentication-related providers.
abstract class AuthBaseNotifier<T> extends StateNotifier<AsyncValue<T?>> {
  AuthBaseNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Process authenticated user and handle common post-authentication tasks.
  /// This prevents code duplication across different auth providers.
  Future<AppUser?> processAuthenticatedUser(
    User user, {
    String providerId = '',
  }) async {
    try {
      final userId = user.uid;
      'Processing authenticated user: $userId'.log('AuthBaseNotifier');

      // Get user data from Firestore
      var firestoreUser = await ref.read(firestoreProvider).getCurrentUser();

      // If user not found in Firestore, create a new user
      if (firestoreUser == null) {
        // For social logins, we need to extract the provider data
        if (providerId.isNotEmpty) {
          final providerData =
              user.providerData
                  .where((e) => e.providerId == providerId)
                  .firstOrNull;

          if (providerData == null) {
            throw Exception('Provider data not found for $providerId');
          }

          firestoreUser = AppUser(
            userid: userId,
            isEmailVerified: user.emailVerified,
            email: user.email ?? providerData.email ?? '',
            name: user.displayName ?? providerData.displayName ?? 'User',
            photoURL: user.photoURL ?? providerData.photoURL,
          );
        } else {
          // For email auth, we don't need provider data
          firestoreUser = AppUser(
            userid: userId,
            isEmailVerified: user.emailVerified,
            email: user.email ?? '',
            name: user.displayName ?? 'User',
            photoURL: user.photoURL,
          );
        }

        // Create user in Firestore
        firestoreUser = await ref
            .read(firestoreProvider)
            .createUser(firestoreUser);
        'New user created in Firestore'.log('AuthBaseNotifier');
      }

      // Get device token and update user data
      final token = await ref.read(firebaseMessagingProvider).getToken();
      await ref.read(firestoreProvider).addToken(token, userId);

      // Navigate based on condition
      ref.read(routerProvider).navigateBasedAuthStatus();

      return firestoreUser;
    } catch (e) {
      'Post-authentication error: $e'.log('AuthBaseNotifier');
      rethrow;
    }
  }

  /// Common error handling for all auth providers
  void handleError(Object e, StackTrace s) {
    'Authentication error: $e'.log('AuthBaseNotifier');
    ref.showExceptionSheet(e);
    state = AsyncValue.error(e, s);
  }
}
