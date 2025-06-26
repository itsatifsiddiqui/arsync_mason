# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter project by Arsync Solutions that follows a strict 4-layer architecture pattern using Riverpod for state management, Freezed for data models, and Flutter Hooks for local UI state.

A complete plan for the project has been written to [specs/project_plan.md](specs/project_plan.md)

## Key Commands

### Development Commands (via RPS)

The project uses [RPS (Run Project Scripts)](https://pub.dev/packages/rps) for task management. All commands follow the pattern: `rps <category> <script>`

**Essential Commands:**
- `rps flutter get` - Install dependencies
- `rps codegen build` - Generate Freezed/JSON serialization code
- `rps codegen watch` - Watch mode for code generation
- `rps lint dart` - Run Dart analyzer
- `rps lint riverpod` - Run Riverpod-specific linter
- `rps lint format` - Format Dart code

**Build Commands:**
- `rps android build` - Build Android APK and bundle
- `rps ios build` - Build iOS app
- `rps ios pods install` - Install iOS pods

**Testing & Development:**
- `rps firebase start` - Start Firebase emulators
- `rps deeplink android` - Test Android deep links
- `rps deeplink ios` - Test iOS deep links

### Manual Commands (if RPS unavailable)
- `flutter pub get` - Install dependencies
- `dart run build_runner build --delete-conflicting-outputs` - Generate code
- `dart analyze` - Run analyzer
- `dart run custom_lint` - Run Riverpod linter
- `dart format lib` - Format code

## Architecture Overview

### 4-Layer Architecture (STRICTLY ENFORCED)

1. **Presentation Layer** (`screens/`, `widgets/`) - Dumb UI components
2. **ViewModel Layer** (`providers/`) - State management and business logic
3. **Model Layer** (`models/`) - Immutable data structures using Freezed
4. **Repository Layer** (`repositories/`) - Data access abstraction

**Critical Rule:** Widgets must NEVER directly access repositories or contain business logic.

### Provider Types (ONLY use these in ViewModels)

- `NotifierProvider` - Synchronous state management
- `AsyncNotifierProvider` - Asynchronous operations
- `StreamNotifierProvider` - Real-time streams
- `StateProvider` - Simple UI state only (booleans, strings, numbers)
- `FutureProvider`/`StreamProvider` - Read-only data fetching

**NEVER use:** `StateNotifierProvider`, `ChangeNotifierProvider`

### Widget Types

- `ConsumerWidget` - Access Riverpod providers
- `HookConsumerWidget` - Combine Flutter Hooks + Riverpod
- `StatelessWidget` - Simple display widgets

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── my_app.dart              # MyApp widget with routing
├── app_theme.dart           # Theme configuration
├── models/                  # Freezed data models with JSON serialization
│   └── user/               # AppUser model example
├── providers/              # Riverpod providers (ViewModels)
│   ├── auth/              # Authentication providers
│   ├── user/              # User-related providers  
│   └── core/              # Core providers (router, theme, preferences)
├── repositories/          # Data access layer
├── screens/              # UI screens organized by feature
│   ├── auth/            # Login, register, forgot password
│   ├── splash/          # Splash screen
│   └── tabs_view/       # Main app navigation with tabs
├── widgets/             # Reusable UI components (Primary*)
└── utils/              # Utilities, extensions, constants
```

## Code Generation

This project heavily uses code generation. **Always run after model changes:**

```bash
rps codegen build
```

Generated files (`.freezed.dart`, `.g.dart`) are NOT committed to version control.

## UI Components (Design System)

**MANDATORY: Use existing Primary widgets instead of native Flutter widgets:**

- `PrimaryButton` (not `ElevatedButton`)
- `PrimaryTextField` (not `TextField`) 
- `PrimaryCard` (not `Card`)
- `PrimaryProgressIndicator` (not `CircularProgressIndicator`)
- `PrimaryErrorWidget` for error states
- `PrimarySheet` for bottom sheets

## Key Dependencies

- **State Management:** `hooks_riverpod` ^2.6.1
- **Local State:** `flutter_hooks` ^0.21.2  
- **Code Generation:** `freezed` ^3.0.6, `json_serializable` ^6.9.5
- **Navigation:** `go_router` ^15.2.4
- **Persistence:** `shared_preferences` ^2.5.3
- **UI Enhancement:** `cached_network_image` ^3.4.1

## Critical Rules

1. **Layer Communication:** Presentation → ViewModel → Repository → Model (never skip layers)
2. **Error Handling:** Always use `ref.showExceptionSheet(e)` in providers
3. **Code Generation:** Run `rps codegen build` after model changes
4. **Widget Design:** Extract complex UI into private widget classes (not methods)
5. **State Management:** Use Flutter Hooks for local UI state, Riverpod for global state
6. **Linting:** All code must pass `rps lint dart` and `rps lint riverpod`

## Development Workflow

1. Make changes to models → Run `rps codegen build`
2. Create new providers following the ViewModel patterns
3. Build UI with Primary widgets and proper error handling
4. Run linter: `rps lint dart && rps lint riverpod`
5. Format code: `rps lint format`

## Architecture Guidelines

For complete architecture details, refer to the comprehensive rules in:
- [Architecture](ai_instructions/architecture.md) - Complete 4-layer architecture specification
- [Copilot Rules](ai_instructions/copilot_rules.md) - Coding conventions and widget patterns
- [Cursor Rules](ai_instructions/.cursorrules) - Additional development guidelines

**Important:** Always follow the strict provider type restrictions and layer communication rules defined in the architecture documentation.