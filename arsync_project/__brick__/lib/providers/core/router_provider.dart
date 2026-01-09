import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/tabs_view/home_tab/home_tab.dart';
import '../../screens/tabs_view/profile/profile_tab.dart';
import '../../screens/tabs_view/tab2/tab2.dart';
import '../../screens/tabs_view/tab3/tab3.dart';
import '../../screens/tabs_view/tabs_view.dart';
import '../auth/auth_provider.dart';
import '../user/app_user_provider.dart';

final routerProvider = Provider((ref) {
  return _RouterProvider(ref);
});

class _RouterProvider {
  final navigatorKey = GlobalKey<NavigatorState>();
  late GoRouter router;
  final Ref ref;

  _RouterProvider(this.ref) {
    router = GoRouter(
      initialLocation: SplashScreen.routeLocation,
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: SplashScreen.routeLocation,
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: RegisterScreen.routeLocation,
          name: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: LoginScreen.routeLocation,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: ForgotPasswordScreen.routeLocation,
          name: ForgotPasswordScreen.routeName,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return TabsView(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: HomeTab.routeLocation,
                  name: HomeTab.routeName,
                  builder: (context, state) => const HomeTab(),
                  routes: [
                    // Home Tab routes will be added here
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Tab2.routeLocation,
                  name: Tab2.routeName,
                  builder: (context, state) => const Tab2(),
                  routes: [
                    // Tab2 routes will be added here
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Tab3.routeLocation,
                  name: Tab3.routeName,
                  builder: (context, state) => const Tab3(),
                  routes: [
                    // Tab3 routes will be added here
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ProfileTab.routeLocation,
                  name: ProfileTab.routeName,
                  builder: (context, state) => const ProfileTab(),
                  routes: [
                    // Profile Tab routes will be added here
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: SelectableText.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Error: ',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(text: state.error.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(milliseconds: 1000), navigateBasedAuthStatus);
  }

  // Initial navigation based on auth status
  Future<void> navigateBasedAuthStatus() async {
    final savedUser = await ref.read(authProvider.notifier).getUser();
    // Not Logged In
    if (savedUser == null) {
      router.goNamed(LoginScreen.routeName);
      return;
    }

    ref.read(appUserProvider.notifier).setUser(savedUser);

    router.goNamed(HomeTab.routeName);
  }

  Future<void> navigateToNamed(String routeName, {Object? extra}) async {
    router.pushNamed(routeName, extra: extra);
  }

  Future<void> replaceToNamed(String routeName, {Object? extra}) async {
    router.replaceNamed(routeName, extra: extra);
  }
}
