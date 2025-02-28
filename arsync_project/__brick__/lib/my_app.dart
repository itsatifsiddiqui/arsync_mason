import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_theme.dart';
import 'providers/router_provider.dart';
import 'providers/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationProvider = ref.read(routerProvider);

    return MaterialApp.router(
      routerConfig: navigationProvider.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      {{#hasDarkMode}}
      darkTheme: AppTheme.darkTheme,
      {{/hasDarkMode}}
      themeMode: ref.watch(themeModeProvider),
      builder: (context, child) {
        return _Unfocus(child: child);
      },
    );
  }
}

class _Unfocus extends StatelessWidget {
  const _Unfocus({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
