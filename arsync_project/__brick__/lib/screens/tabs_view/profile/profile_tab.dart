import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/router_provider.dart';
import '../../../providers/shared_preferences_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/primary_button.dart';

class ProfileTab extends ConsumerWidget {
  static String get routeName => 'profile';
  static String get routeLocation => '/$routeName';
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          ...kThemeModes.keys.map((themeKey) {
            return ListTile(
              onTap: () => updateTheme(ref, themeKey),
              title: Text('Tap to Switch to $themeKey Mode'),
            );
          }),
          PrimaryButton(
            onTap: () async {
              final result = await context.showConfirmationDialog(
                'Logout?',
                message: 'Are you sure you want to logout?',
              );

              if (result != true) return;
              ref.read(routerProvider).navigateBasedAuthStatus();
            },
            color: Colors.red,
            text: 'Logout',
          ).p16()
        ],
      ),
    );
  }

  void updateTheme(WidgetRef ref, String text) {
    ref.read(themeModeProvider.notifier).update((_) => kThemeModes[text]!);
    ref.read(sharedPreferencesProvider).setTheme(text);
  }
}
