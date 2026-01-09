import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_loading_indicator.dart';
import '../../widgets/primary_text_field.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  static String get routeName => 'forgot_password';
  static String get routeLocation => '/$routeName';
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final formkey = GlobalObjectKey<FormState>(context);
    final isLoading = useState(false);
    return PrimaryLoadingIndicator(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(title: const Text('Forgot Password')),
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
                24.heightBox,
                PrimaryButton(
                  onTap: () async {
                    if (formkey.currentState!.validate() != true) return;
                    final email = emailController.text.trim();
                    forgotPassword(email, ref, isLoading);
                  },
                  text: 'Send Reset Link',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgotPassword(
    String email,
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
      if (!success) throw 'Failed to send reset link';

      if (!context.mounted) return;
      context.showSuccessSnackBar('Reset link sent successfully');
      context.goNamed(LoginScreen.routeName);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
