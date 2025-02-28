import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Tab2 extends HookConsumerWidget {
  static String get routeName => 'tab2';
  static String get routeLocation => '/$routeName';
  const Tab2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Tab2'),
      ),
    );
  }
}
