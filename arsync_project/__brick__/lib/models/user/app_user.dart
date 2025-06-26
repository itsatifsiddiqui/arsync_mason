import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum UserType { user, admin }

dynamic readUserId(Map map, String key) =>
    map['userid'] ?? map['uid'] ?? map['userId'];

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    @JsonKey(readValue: readUserId) required String userid,
    required String name,
    required String email,
    String? photoURL,
    @Default(false) bool isEmailVerified,
    @Default(UserType.user) UserType userType,
    required bool isActive,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromFirestore(Map<String, dynamic> json, String id) {
    return _$AppUserFromJson(json).copyWith(userid: id);
  }
}
