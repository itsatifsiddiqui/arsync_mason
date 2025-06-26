## Project Guidelines

### 1. Naming Conventions
- **Files**: snake_case (e.g., `login_screen.dart`)
- **Classes**: PascalCase (e.g., `LoginScreen`, `AppUser`)
- **Variables/Methods**: camelCase (e.g., `emailController`, `validateForm`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`)
- **Private widgets**: Prefix with underscore (e.g., `_LoginForm`)

## Architecture Reference

**IMPORTANT**: Before writing any code, always refer to the complete architecture guide:
📋 **Architecture Guide**: [Architecture Guidelines](../ai_instructions/architecture.md)

This file contains the complete 4-layer architecture pattern, provider rules, and detailed implementation guidelines that must be followed strictly.

## Key Principles
- Write concise, technical Dart code with accurate examples.
- Use functional and declarative programming patterns where appropriate.
- Prefer composition over inheritance.
- Use descriptive variable names with auxiliary verbs (e.g., isLoading, hasError).
- Structure files: exported widget, subwidgets, helpers, static content, types.
- Prefer using private widgets over methods.
- Only use methods for building widgets, where it is used only once.

## Dart/Flutter
- Use const constructors for immutable widgets.
- Use arrow syntax or code block to make the code more readable for simple functions and methods.
- Prefer expression bodies for one-line getters and setters.
- Use trailing commas for better formatting and diffs.

## Screen Structure Guidelines

### Lean Screen Architecture
- **Keep the body widget lean and organized**
- **The body widget must not contain any Rows or Columns except the root level scrollable widget**
- **Break down complex UI into private widget classes**
- **Use composition over large widget trees**

### Private Widget Composition Rules
```dart
// ✅ CORRECT: Lean screen with private widget composition
class LoginScreen extends HookConsumerWidget {
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';
  
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider watches
    final authState = ref.watch(authProvider);
    
    // Effects
    useEffect(() {
      // Side effects
      return () {
        // Cleanup
      };
    }, []);
    
    // ✅ Body widget is lean - only root scrollable widget
    return Scaffold(
      body: SingleChildScrollView(  // Only root level scrollable
        child: Column(  // Only Column/Row allowed at root level
          children: [
            // ✅ Break down into private composable widgets
            _HeaderSection(),
            _LoginFormSection(
              emailController: emailController,
              passwordController: passwordController,
            ),
            _FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _LoginFormSection extends HookConsumerWidget {
  
  const _LoginFormSection({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks at the top
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalObkectKey<FormState>(context);
    
    
    return Form(  // Only root level scrollable
        key: formKey,
        child: Column(  // Only Column/Row allowed at root level
          children: [
            // ✅ Break down into private composable widgets
            PrimaryTextField(
              controller: emailController,
              title: 'Email',
              validator: Validators.emailValidator,
            ),
            PrimaryTextField(
              controller: passwordController,
              title: 'Password',
              validator: Validators.passwordValidator,
              obscureText: true,
            ),
          ],
        ),
      );
  }
}
```

### 3. Model Structure (Freezed)
```dart
@freezed
abstract class ModelName with _$ModelName {
  const factory ModelName({
    @JsonKey(includeToJson: false) String? id,
    required String field1,
    required String field2,
    @Default(false) bool isActive,
  }) = _ModelName;

  const ModelName._();

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
      
  factory ModelName.fromFirestore(Map<String, dynamic> json, String id) {
    return _$ModelNameFromJson(json).copyWith(id: id);
  }
}
```

### 4. Repository Pattern
```dart
final repositoryProvider = Provider<Repository>((ref) {
  return Repository();
});

class Repository {
  // Data operations
  Future<Model> getData() async {
    // Implementation
  }
  
  Future<void> saveData(Model data) async {
    // Implementation
  }
}
```

### 5. Provider Pattern
```dart
final providerName = StateNotifierProvider<ProviderNotifier, State>((ref) {
  return ProviderNotifier(ref);
});

class ProviderNotifier extends StateNotifier<State> {
  final Ref ref;
  
  ProviderNotifier(this.ref) : super(initialState);
  
  Future<void> performAction() async {
    state = state.copyWith(isLoading: true);
    try {
      // Business logic
      final result = await ref.read(repositoryProvider).getData();
      state = state.copyWith(data: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

## UI/UX Guidelines

### 1. Design System
- **Font Family**: Inter (weights 100-900)
- **Primary Color**: `#e02f32` (red theme)
- **Border Radius**: 8dp default (`kBorderRadius`)
- **Spacing**: 8dp base unit (use `.heightBox`, `.widthBox` extensions)
- **Padding**: 16dp standard content padding

### 2. Component Usage
- **Buttons**: Use `PrimaryButton` widget
- **Text Fields**: Use `PrimaryTextField` widget
- **Cards**: Use `PrimaryCard` widget
- **Loading**: Use `PrimaryLoadingIndicator` widget
- **Sheets**: Use `PrimarySheet` widget

### 3. Theme Support
- Support both light and dark themes
- Use adaptive colors: `context.adaptive`, `context.adaptive87`, etc.
- Use theme-aware colors: `context.primaryColor`, `context.cardColor`

### 4. Navigation
- Use GoRouter for navigation
- Define route names and locations as static getters
- Use `context.pushNamed()` for navigation
- Keep TabsView at bottom of navigation stack

## Development Rules

### 1. Riverpod-Specific Guidelines
- **STRICT PROVIDER RULES**: Refer to [Architecture Guidelines](./architecture.md) for complete provider type restrictions
- **ViewModels/Providers Layer**: Only use `NotifierProvider`, `AsyncNotifierProvider`, `StreamNotifierProvider`
- **Error Handling**: Use `ref.showExceptionSheet(e)` to show error messages from ViewModels
- Prefer FutureProvider and StreamProvider for simple data fetching (not in ViewModel layer)
- Avoid StateProvider, StateNotifierProvider, and ChangeNotifierProvider in ViewModel layer
- Use ref.invalidate() for manually triggering provider updates
- Implement proper cancellation of asynchronous operations when widgets are disposed

### 2. Code Quality
- Use `analysis_options.yaml` linting rules
- Prefer `const` constructors where possible
- Use early returns to avoid deep nesting
- Use string interpolation over concatenation
- Leverage existing Primary widgets instead of creating new ones

### 3. State Management Rules
- Use Flutter Hooks for local state
- Use Riverpod providers for global state
- Avoid `StateProvider` - prefer `StateNotifierProvider`
- Use `ref.invalidate()` for manual provider updates
- Implement proper error handling with `AsyncValue`

### 4. Error Handling
- Display errors using `SelectableText.rich` with red color
- Handle empty states within displaying screens
- Use try-catch blocks in providers
- Log errors using custom logging extensions

### 5. Performance
- Use `const` widgets where possible
- Implement `ListView.builder` for large lists
- Use `cached_network_image` for remote images
- Implement proper disposal in hooks and providers

### 5. Firebase Integration
- Use Firebase Auth for authentication
- Use Firestore for data storage
- Handle network errors properly
- Use Firebase emulator for development


## Performance Optimization
- Use const widgets where possible to optimize rebuilds
- Implement list view optimizations (e.g., ListView.builder)
- Use AssetImage for static images and cached_network_image for remote images

## Key Conventions

2. Prefer stateless widgets:
   - Use ConsumerWidget with Riverpod for state-dependent widgets
   - Use HookConsumerWidget when combining Riverpod and Flutter Hooks

## File Structure
- Keep related files in feature folders
- Use `part` files for generated code (Freezed, JSON)
- Group providers by feature in subfolders
- Keep utilities and extensions in utils folder

## UI and Styling
- Use Flutter's built-in widgets and create custom widgets
- Use themes for consistent styling across the app
- Use context.adaptive for adaptive text color as it manages light and dark text color
- Always use Iconsax icons over material icons only if iconsax package is installed, if not installed don't try to add it.

## Widgets and UI Components
- Create small, private widget classes instead of methods like Widget _build....
- Implement RefreshIndicator for pull-to-refresh functionality
- In TextFields, set appropriate textCapitalization, keyboardType, and textInputAction
- Always use CachedNetworkImage for remote images

## Strict Rules - NEVER BREAK

1. **NEVER** modify existing Primary widgets heavily - extend with parameters instead
2. **NEVER** use code generation for Riverpod (`@riverpod` annotations)
3. **NEVER** skip error handling in async operations except for `Repositories`
4. **NEVER** use `print()` - use logging extensions instead
5. **NEVER** hardcode strings - use constants or localization
6. **NEVER** ignore linting warnings without good reason
7. **NEVER** commit generated files to version control
8. **NEVER** use `setState` - use Hooks or Riverpod instead
9. **NEVER** create widgets without proper key handling
10. **NEVER** skip input validation in forms

Follow these rules strictly to maintain code quality, consistency, and project architecture integrity.