import 'package:hooks_riverpod/hooks_riverpod.dart';
{{#login_with_apple}}
import '../../../providers/auth/login_with_apple_provider.dart';
{{/login_with_apple}}
{{#login}}
import '../../../providers/auth/login_with_email_provider.dart';
{{/login}}
{{#login_with_google}}
import '../../../providers/auth/login_with_google_provider.dart';
{{/login_with_google}}
{{#phone_auth}}
import '../../../providers/auth/login_with_phone_provider.dart';
{{/phone_auth}}
{{#passwordless_email}}
import '../../../providers/auth/passwordless_email_signin_provider.dart';
{{/passwordless_email}}
{{#signup}}
import '../../../providers/auth/sign_up_provider.dart';
{{/signup}}

final authLoadingProvider = StateProvider((ref) {
  final loadersList = [
    {{#signup}}
    ref.watch(
      signupWithEmailPasswordProvider.select((value) => value.isLoading),
    ),
    {{/signup}}
    {{#login}}
    ref.watch(loginWithEmailProvider.select((value) => value.isLoading)),
    {{/login}}
    {{#login_with_google}}
    ref.watch(loginWithGoogleProvider.select((value) => value.isLoading)),
    {{/login_with_google}}
    {{#login_with_apple}}
    ref.watch(loginWithAppleProvider.select((value) => value.isLoading)),
    {{/login_with_apple}}
    {{#phone_auth}}
    ref.watch(loginWithPhoneProvider.select((value) => value.isLoading)),
    {{/phone_auth}}
    {{#passwordless_email}}
    ref.watch(passwordlessEmailProvider.select((value) => value.isLoading)),
    {{/passwordless_email}}
  ];
  return loadersList.contains(true);
});
