import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_app.dart';
import 'providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  _setPortraitMode();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWith(
        (ref) => SharedPreferencesProvider(prefs, ref),
      ),
    ],
    child: const MyApp(),
  ));
}

// Lock the Portrait Orientation.
void _setPortraitMode() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}
