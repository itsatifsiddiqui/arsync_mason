# AIPackNFind Project Rules

## Core Guidelines

1. **Frontend Only Development**: We are currently focused only on UI implementation. No backend integration, API calls, or persistence logic should be implemented at this stage.

2. **In-Memory Data**: All data should be stored in-memory using static lists within model classes. No local or remote database implementations should be added.

3. **Widget Preservation**: Use existing widgets from the `/lib/widgets` directory without heavy modifications. If new behavior is needed, add parameters instead of changing core functionality.

4. **Utility Preservation**: Use existing utilities from the `/lib/utils` directory as-is. Add new utility functions or parameters if needed, but don't modify existing implementations.

## Coding Style

### Flutter Hooks Usage

Always use Flutter Hooks for stateful logic where applicable:

```dart
import 'package:flutter_hooks/flutter_hooks.dart';

class MyScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    return Text('Counter: ${counter.value}');
  }
}
```

### State Management

- Use Riverpod without code generation (no `@riverpod` annotations)
- Use `ConsumerWidget` or `HookConsumerWidget` for access to providers
- Keep state management logic simple and contained

### Model Generation

- Use Freezed for data class generation to ensure immutability
- Always exclude ID fields from JSON serialization using `@JsonKey(includeToJson: false)`
- Include a `fromFirestore` factory method to handle document ID assignment
- Include static lists within models for in-memory data storage
- Example model pattern:

```dart
@freezed
class ModelName with _$ModelName {
  const factory ModelName({
    @JsonKey(includeToJson: false) String? id,
    required String field1,
    required String field2,
    // other fields
  }) = _ModelName;

  const ModelName._();

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
      
  factory ModelName.fromFirestore(Map<String, dynamic> json, String id) {
    return _$ModelNameFromJson(json).copyWith(id: id);
  }
  
  // Static data for in-memory usage
  static List<ModelName> get sampleData => [
    // sample items
  ];
}
```

### Naming Conventions

- **Variables & methods**: camelCase (e.g., `userName`, `fetchData()`)
- **Classes & enums**: PascalCase (e.g., `UserSession`, `AppTheme`)
- **File names**: snake_case (e.g., `session_history_model.dart`)
- Match filename and main widget name (e.g., `my_screen.dart` → `class MyScreen`)

### Widget Structure

- Extract large widgets into smaller, reusable components
- Use `_` prefix for private widgets used within a single file
- Early return pattern for conditional logic:
  ```dart
  if (formKey.currentState?.validate() != true) return;
  // continue with logic
  ```

## Design Guidelines

### Reference Guidelines

- Follow [UI Design Guidelines](design_guidelines/ui_design.md)
- Follow [UX Design Guidelines](design_guidelines/ux_design.md)
- Follow [Onboarding Flow](flows/onboarding.md) for tutorial screens
- Ensure all designs support both light and dark mode

### Color System

- Use the color system defined in `AppColors` class
- Primary: #4CAF50 (Green) and its variants
- Support adaptive colors based on light/dark mode

### Typography

- **Font Family**: Inter (already included in assets)
- **Text Styles**:
  - Heading: 20sp, Inter SemiBold
  - Body: 16sp, Inter Regular
  - Caption: 14sp, Inter Regular
  - Button: 16sp, Inter Medium
- Use the theme's text styles wherever possible: `Theme.of(context).textTheme`

### Icons

- Use the Iconsax library for all icons
- Standard size: 24dp
- Compact size: 20dp
- Interactive icons: Primary color
- Decorative icons: Secondary color

### Components

#### Buttons
- Use `PrimaryButton` widget
- Width: Context-appropriate (match parent or content)

#### Text Fields
- Use `PrimaryTextField` widget
- Include appropriate validators from `Validators` class
- Use Proper `KeyboardType` based on context (email, phone, etc.)
- Use `TextInputAction` based on context (next, done, etc.)
- Use `TextInputFormatter` for formatting (e.g., phone number)

#### Cards
- Use `PrimaryCard` widget
- Primary Card already has padding, so no need to add extra padding to the childs.
- Proper padding (16dp standard)
- Use `PrimaryCard` for displaying lists or grouped content
- Use `PrimaryCard` for displaying images or media
- Use `PrimaryCard` for displaying user information or profiles

### Layout

- Base spacing unit: 8dp
- Content padding: 16dp from screen edges
- Vertical spacing between elements: 16dp
- Minimum touch targets: 48x48dp

## Project Structure

```
lib/
  ├── app_theme.dart          # Theme definitions
  ├── main.dart               # Entry point
  ├── my_app.dart             # Root App widget
  ├── models/                 # Data models with static lists
  ├── providers/              # Riverpod providers
  ├── screens/                # UI screens organized by feature
  ├── utils/                  # Utility functions and extensions
  └── widgets/                # Reusable UI components
```

### Important Directories

- **models/**: Contains data models with static lists for in-memory data
- **screens/**: Organized by feature (auth, onboarding, etc.)
- **widgets/**: Contains reusable components like `PrimaryButton`, `PrimaryCard`, etc.
- **utils/**: Contains utility functions like validators, extensions, and constants

## Specific Do's and Don'ts

### Do's
- ✅ Use Flutter Hooks for state management
- ✅ Follow the UI/UX guidelines for consistent design
- ✅ Use existing widgets from widgets/ directory
- ✅ Implement proper navigation between screens
- ✅ Support both light and dark modes
- ✅ Use static lists in model classes
- ✅ Create modular, reusable components
- ✅ Use Iconsax for icons

### Don'ts
- ❌ Implement backend integration or API calls
- ❌ Add local or remote database functionality
- ❌ Heavily modify existing utility classes or widgets
- ❌ Use code-generation features of Riverpod
- ❌ Create new design patterns outside the guidelines
- ❌ Use inconsistent styling across screens