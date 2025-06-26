import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/auth/auth_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_loading_indicator.dart';
import '../../widgets/primary_text_field.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends HookConsumerWidget {
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formkey = GlobalObjectKey<FormState>(context);
    final emailController = useTextEditingController(
      text: kDebugMode ? 'atif@gmail.com' : null,
    );
    final passwordController = useTextEditingController(
      text: kDebugMode ? '123456' : null,
    );

    final isLoading = ref.watch(authProvider).isLoading;

    final showPassword = useState(false);

    return PrimaryLoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Login Screen')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                0.2.sh(context).heightBox,
                PrimaryTextField(
                  controller: emailController,
                  title: 'Email',
                  validator: Validators.emailValidator,
                  hintText: 'Enter your email',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                16.heightBox,
                PrimaryTextField(
                  controller: passwordController,
                  title: 'Password',
                  validator: Validators.passwordValidator,
                  hintText: 'Enter your password',
                  obscureText: !showPassword.value,
                  suffixIcon: IconButton(
                    onPressed: () => showPassword.value = !showPassword.value,
                    icon: Icon(
                      showPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  onSubmitAction: () {
                    if (formkey.currentState!.validate() != true) return;
                    final email = emailController.text.trim().toLowerCase();
                    final password = passwordController.text.trim();
                    ref
                        .read(authProvider.notifier)
                        .signinWithEmailAndPassword(email, password);
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(ForgotPasswordScreen.routeName);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                16.heightBox,
                PrimaryButton(
                  onTap: () async {
                    if (formkey.currentState!.validate() != true) return;
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    ref
                        .read(authProvider.notifier)
                        .signinWithEmailAndPassword(email, password);
                  },
                  text: 'Login',
                ),
                12.heightBox,
                TextButton(
                  onPressed: () {
                    context.pushNamed(RegisterScreen.routeName);
                  },
                  child: const Text('Create a new account'),
                ),
              ],
            ),
          ).safeArea(),
        ),
      ),
    );
  }
}
