import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/app_user.dart';
import '../../utils/utils.dart';

final firestoreProvider = Provider((ref) {
  return FirestoreProvider(ref: ref);
});

class FirestoreProvider {
  final Ref ref;
  FirestoreProvider({required this.ref});

  final _firestore = FirebaseFirestore.instance;

  DocumentReference<AppUser?> _userRef(String uid) {
    final ref = _firestore.collection('users').doc(uid);
    return ref.withConverter(
      fromFirestore: (e, _) {
        if (e.data() == null) return null;
        return AppUser.fromJson(e.data()!);
      },
      toFirestore: (e, _) {
        return e?.toJson() ?? {};
      },
    );
  }

  Future<AppUser?> getCurrentUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) throw 'Not logged in';

    final user = await _userRef(userId).get();
    return user.data();
  }

  Stream<AppUser?> watchUser(String userId) {
    return _userRef(userId).snapshots().map((event) => event.data());
  }

  Future<AppUser> getUser(String userId) async {
    final user = await _userRef(userId).get();
    final userData = user.data();
    if (userData == null) throw Exception('User data is null');
    return userData;
  }

  Future<AppUser?> createUser(AppUser appUser) async {
    try {
      final updatedAppUser = AppUser.fromJson({
        ...appUser.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _userRef(appUser.userid!).set(updatedAppUser);
      return appUser;
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<void> addToken(String? token, String userId) async {
    if (token == null) return;
    // Using set without converter because we're only updating specific fields
    await _firestore.collection('users').doc(userId).set({
      'tokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  Future<void> removeToken(String? token, String userId) async {
    if (token == null) return;
    final userRef = _userRef(userId);
    await userRef.update({
      'tokens': FieldValue.arrayRemove(<String>[token]),
    });
  }

  Future<AppUser> updateUser(AppUser user) async {
    'Updating user: $user'.log();

    try {
      final updatedUser = {
        ...user.toJson(),
        'keywords': generateBigram(user.name),
      };

      await _userRef(user.userid!).update(updatedUser);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
