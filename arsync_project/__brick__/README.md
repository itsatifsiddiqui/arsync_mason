# {{projectname.titleCase()}}

A Project by Arsync Solutions.

## Project Structure

The project follows a modular architecture with clear separation of concerns:

```
lib/
├── models/       # Data models and DTOs using Freezed
├── providers/    # Riverpod providers and state management
├── screens/      # UI screens and pages
├── widgets/      # Reusable UI components
├── hooks/        # Custom Flutter Hooks
├── utils/        # Utility functions and helpers
├── app_theme.dart # Theme configuration
├── my_app.dart   # App configuration
└── main.dart     # Entry point
```

## Code Generation

This project uses several code generation tools:

1. **Freezed** - For immutable data models
2. **JSON Serializable** - For JSON serialization/deserialization
3. **Build Runner** - For running code generators

To generate code after making changes to models:

```bash
# Using RPS script
rps codegen:build

# Or directly
dart run build_runner build --delete-conflicting-outputs
```

## RPS Scripts

This project uses [RPS (Run Project Scripts)](https://pub.dev/packages/rps) for common development tasks. RPS allows you to define and run scripts from the `rps.yaml` file.

### Installation

RPS is already configured in this project. If you need to install it globally:

```bash
dart pub global activate rps
```

### Usage

Run any script using the format:

```bash
rps <category>:<script>
```

For example:
```bash
rps codegen:build
```

You can also list all available commands:
```bash
rps ls
```

### Available Scripts

#### Flutter
- `rps flutter:get` - Run flutter pub get
- `rps flutter:clean` - Clean the project
- `rps flutter:outdated` - Check for outdated packages
- `rps flutter:upgrade` - Upgrade packages
- `rps flutter:gen_l10n` - Generate localization files

#### Code Generation
- `rps codegen:build` - Run build_runner once
- `rps codegen:watch` - Run build_runner in watch mode (watches for file changes)
- `rps codegen:icons` - Generate app icons from assets/images/icon.png
- `rps codegen:splash` - Generate splash screen from assets/images/splash.png

#### Linting
- `rps lint:dart` - Run Dart analyzer
- `rps lint:riverpod` - Run Riverpod linter (custom_lint)
- `rps lint:format` - Format Dart code in lib directory

#### Firebase
- `rps firebase:start` - Start Firebase emulators with data persistence
- `rps firebase:startfresh` - Start Firebase emulators with fresh data
- `rps firebase:stop` - Stop Firebase emulators
- `rps firebase:local` - Open Firebase local console

#### iOS Build
- `rps ios:pods:install` - Install iOS pods with repo update
- `rps ios:pods:clean` - Clean and reinstall pods
- `rps ios:pods:update` - Update pods
- `rps ios:build` - Build iOS app (clean, get packages, update pods, build)
- `rps ios:buildnosign` - Build iOS app without signing
- `rps xcode:open` - Open Xcode workspace

#### Android Build
- `rps android:build` - Build Android APK and bundle, then open output directory
- `rps android:installrelease` - Install release APK on connected device
- `rps android:openapk` - Open APK folder

#### Deep Linking
- `rps deeplink:android` - Test Android deep link
- `rps deeplink:ios` - Test iOS deep link

#### Utility
- `rps kill8080` - Kill process on port 8080 (Firebase Emulators)
- `rps kill4000` - Kill process on port 4000
- `rps kill5001` - Kill process on port 5001
- `rps kill9099` - Kill process on port 9099
- `rps kill9199` - Kill process on port 9199

### Adding New Scripts

To add or modify scripts, edit the `rps.yaml` file in the project root. Example:

```yaml
scripts:
  # Add a new script category
  deploy:
    # Add a new script
    staging: flutter build appbundle --flavor staging
    production: flutter build appbundle --flavor production
```

Then run it with:
```bash
rps deploy:staging
```

## Firebase Setup

For Firebase Authentication and other Google services, you need to add SHA keys to your Firebase project.

The SHA keys have been automatically generated and saved in the `notes.txt` file.

### Generating SHA keys manually

For debug key:
```
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android
```

For release key:
```
keytool -list -v -alias upload -keystore ./keys/upload-keystore.jks
```

Add these keys to your Firebase project in the Firebase console under:
Project settings > Your apps > SHA certificate fingerprints