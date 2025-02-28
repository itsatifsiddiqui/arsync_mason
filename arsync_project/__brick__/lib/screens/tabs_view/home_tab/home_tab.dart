import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/utils.dart';

class HomeTab extends ConsumerWidget {
  static String get routeName => 'home';
  static String get routeLocation => '/$routeName';
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Happy Coding :)',
            style: TextStyle(fontSize: 24),
          ).centered(),
          16.heightBox,
          const Text(
            'Best of Luck 🤞🏻',
            style: TextStyle(fontSize: 24),
          ).centered(),
        ],
      ),
    );
  }
}
