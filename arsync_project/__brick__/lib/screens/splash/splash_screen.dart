import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';
  const SplashScreen({super.key});

  @override
  _SplashScreenNewState createState() => _SplashScreenNewState();
}

class _SplashScreenNewState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Images.logo,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ).safeArea(),
    );
  }
}
