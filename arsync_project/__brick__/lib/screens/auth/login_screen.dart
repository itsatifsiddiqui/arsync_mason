import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_loading_indicator.dart';
import '../../widgets/primary_text_field.dart';
import '../tabs_view/home_tab/home_tab.dart';
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

    final isLoading = useState(false);

    final showPassword = useState(false);

    return PrimaryLoadingIndicator(
      isLoading: isLoading.value,
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
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    login(email, password, ref, isLoading);
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

                    login(email, password, ref, isLoading);
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

  Future<void> login(
    String email,
    String password,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) async {
    final context = ref.context;

    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Simulate success/failure
      final success = Random().nextBool();

      // We throw error so it can be catched in catch code block.
      if (!success) throw 'Login failed';

      context.showSuccessSnackBar('Logged in successfully');
      context.goNamed(HomeTab.routeName);
    } catch (e) {
      context.showExceptionSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
