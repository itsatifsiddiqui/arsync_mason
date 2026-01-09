import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/auth/auth_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_loading_indicator.dart';
import '../../widgets/primary_text_field.dart';
import '../../widgets/primary_titled_drop_down.dart';

class RegisterScreen extends HookConsumerWidget {
  static String get routeName => 'register';
  static String get routeLocation => '/$routeName';
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formkey = GlobalObjectKey<FormState>(context);
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final gender = useState<String?>(null);

    final isLoading = ref.watch(authProvider).isLoading;

    final showPassword = useState(false);

    return PrimaryLoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Register')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                0.1.sh(context).heightBox,
                PrimaryTextField(
                  controller: nameController,
                  title: 'Name',
                  validator: Validators.nameValidator,
                  hintText: 'Enter your name',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                16.heightBox,
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
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword.value,
                  suffixIcon: IconButton(
                    onPressed: () => showPassword.value = !showPassword.value,
                    icon: Icon(
                      showPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                16.heightBox,
                PrimaryTitledDropDown<String?>(
                  title: 'Gender',
                  items: const ['Male', 'Female', 'Other'],
                  titles: const ['Male', 'Female', 'Other'],
                  value: gender.value,
                  onChanged: (value) => gender.value,
                ),
                24.heightBox,
                PrimaryButton(
                  onTap: () async {
                    if (formkey.currentState!.validate() != true) return;
                    final name = nameController.text.trim();
                    final email = emailController.text.trim().toLowerCase();
                    final password = passwordController.text.trim();

                    ref
                        .read(authProvider.notifier)
                        .signupWithEmailAndPassword(name, email, password);
                  },
                  text: 'Register',
                ),
              ],
            ),
          ).safeArea(),
        ),
      ),
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String? value,
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
      if (!success) throw 'Register failed';
      if (!context.mounted) return;

      context.showSuccessSnackBar('Registered successfully');
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
