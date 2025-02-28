import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';

class TabsView extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const TabsView({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}

class _BottomNavigationBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const _BottomNavigationBar({
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (value) {
        navigationShell.goBranch(
          value,
          initialLocation: value == navigationShell.currentIndex,
        );
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.primaryColor,
      unselectedItemColor: context.adaptive45,
      selectedFontSize: 15,
      unselectedFontSize: 15,
      backgroundColor: context.cardColor,
      enableFeedback: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home).py2(),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.tab).py2(),
          label: 'Tab 2',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.tab).py2(),
          label: 'Tab 3',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person).py2(),
          label: 'Profile',
        ),
      ],
    );
  }
}
