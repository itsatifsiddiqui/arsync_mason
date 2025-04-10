# Flutter Coding Style Guide

### 1. Flutter Hooks Usage
Always use Flutter Hooks (flutter_hooks) for stateful logic where applicable. This improves code readability and promotes reactive patterns.

```dart
import 'package:flutter_hooks/flutter_hooks.dart';

class MyScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useState(0);

    return Text('Counter: ${counter.value}');
  }
}
```

### 2. File & Folder Structure
- Follow the proposed project structure with clear folders for hooks, models, providers, screens, utils, and widgets.
- Keep main.dart, my_app.dart, and global config files (e.g., app_theme.dart) at the root of the lib folder.
- Group related widgets and providers in feature-specific folders (e.g., screens/auth/, providers/auth/).

Example Structure:

```
 lib ➡ tree -L 2
.
├── app_theme.dart
├── hooks
│   └── keyboard_visibility.dart
├── main.dart
├── models
│   ├── app_user.dart
│   ├── app_user.freezed.dart
│   └── app_user.g.dart
├── my_app.dart
├── providers
│   ├── alert_provider.dart
│   ├── app_user_provider.dart
│   ├── auth
│   ├── base_provider.dart
│   ├── firebase_messaging_provider.dart
│   ├── firestore_provider.dart
│   ├── router_provider.dart
│   ├── shared_preferences_provider.dart
│   └── theme_provider.dart
├── screens
│   ├── auth
│   ├── splash
│   └── tabs_view
├── utils
│   ├── alert_extensions.dart
│   ├── app_colors.dart
│   ├── constants.dart
│   ├── debouncer.dart
│   ├── exception_toolkit.dart
│   ├── extensions.dart
│   ├── images.dart
│   ├── logging_extensions.dart
│   ├── padding_extensions.dart
│   ├── utils.dart
│   ├── validators.dart
│   └── widget_utility_extensions.dart
└── widgets
    ├── measure_size.dart
    ├── primary_button.dart
    ├── primary_card.dart
    ├── primary_error_widet.dart
    ├── primary_info_widget.dart
    ├── primary_loading_indicator.dart
    ├── primary_progress_indicator.dart
    ├── primary_sheet.dart
    ├── primary_text_field.dart
    └── primary_titled_drop_down.dart
```

### 3. Naming Conventions
- **Dart naming:**
  - Variables & methods: camelCase (e.g., userName, fetchData()).
  - Classes & enums: PascalCase (e.g., UserSession, AppTheme).
  - File names: snake_case (e.g., session_history_model.dart).
- Match the filename and main widget name (e.g., my_screen.dart → class MyScreen extends StatelessWidget).
- Use descriptive names for classes, methods, variables, and images—avoid cryptic or generic labels.

### 4. Widget Structure & Best Practices
- **Stateful Widgets:** Always call dispose() at the bottom of the class, and keep that logic clear and minimal.
- **Smaller Modular Widgets:** Extract large widgets into smaller, reusable ones. If a widget is used in one place only, prefix it with _ to make it private (e.g., _MyLocalWidget).
- Prefer composition over inheritance where possible.

### 5. Static Lists & Model Organization
Render lists by defining a static list in the model class for clarity. For example:

```dart
class SessionHistoryModel {
  final DateTime date;
  final double rating;
  final String name;

  SessionHistoryModel({
    required this.date,
    required this.rating,
    required this.name,
  });

  static final List<SessionHistoryModel> sessionHistory = [
    // ...
  ];
}
```

### 6. Navigation Rules
- Keep Home/TabsView at the bottom of the navigation stack so that pressing the system Back button on those screens closes the app.
- Organize navigation logic cleanly, typically in providers or well-structured flow methods.

### 7. Colors & Images
- **app_colors.dart:** Centralize color constants. Example:

```dart
// app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF123456);
  // ...
}
```

- **images.dart:** Store descriptive image path constants. Example:

```dart
// images.dart
class AppImages {
  static const loginBackground = 'assets/images/login_background.png';
  static const profileAvatar   = 'assets/images/profile_avatar.png';
  // ...
}
```

### 8. Early Return Pattern
Use early returns to avoid deeply nested conditionals:

```dart
// Instead of:
// if (formKey.currentState.validate() == true) {
//   // do something
// }

// Use:
if (formKey.currentState.validate() != true) return;
// do something
```

### 9. Coding Conventions & Analysis
- Use the provided analysis_options.yaml for linting. Respect warnings and hints.
- Use const constructors wherever possible. Let your IDE auto-insert them upon save.
- Prefer final for variables that are never reassigned and leverage Dart's type inference.
- Use string interpolation over concatenation ('Hello $name' vs 'Hello ' + name).
- Leverage Primary Widgets (e.g., PrimaryButton, PrimaryCard) to maintain consistent design across the app. You can extend these widgets as needed.

### 10. Folder-Specific Guidelines
- **screens/:** Group screens by feature (e.g., auth/, tabs_view/), and have a main widget per file.
- **providers/:** Split providers by domain, keep logic minimal, and consider creating separate classes for complex operations.
- **utils/:** Store app-wide utilities like debouncer.dart, exception_toolkit.dart, app_colors.dart, images.dart, etc.
- **widgets/:** Contains reusable UI elements (PrimaryButton, PrimaryCard, etc.).

### Summary
- Use Flutter Hooks + smaller, modular widgets.
- Dispose logic at the bottom of stateful widgets.
- Early returns to keep conditionals clean.
- Centralize colors/images in app_colors.dart & images.dart.
- Static lists in model classes for data clarity.
- Navigation: Home/TabsView at bottom of the stack.
- Primary Widgets for consistent design.