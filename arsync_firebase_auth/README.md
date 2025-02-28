# arsync_firebase_auth

A Mason brick that generates a comprehensive Firebase authentication system for arsync projects. This brick implements a DRY (Don't Repeat Yourself) approach with a shared base authentication class to eliminate code duplication across multiple authentication providers.

[![Powered by Mason](https://img.shields.io/badge/Powered%20by-Mason-blue.svg)](https://github.com/felangel/mason)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 Features

- **Modular Authentication System**: Generate only the authentication methods you need
- **Riverpod Architecture**: Leverages Riverpod for state management
- **DRY Implementation**: Common authentication logic in a shared base class
- **Comprehensive Error Handling**: Built-in error management across all providers
- **Unified Loading State**: Central provider to track loading status of all auth operations
- **Firebase Integration**: Seamless integration with Firebase Authentication and Firestore

### 🔐 Supported Authentication Methods

- ✅ Email/Password Registration
- ✅ Email/Password Login
- ✅ Google Sign-In
- ✅ Apple Sign-In
- ✅ Phone Authentication with SMS
- ✅ Passwordless Email Authentication (Magic Links)
- ✅ Forgot Password Functionality
- ✅ Email Verification
- ✅ Change Password
- ✅ Account Deletion
- ✅ Logout (with integration for all enabled providers)

## 📦 Installation

```bash
# Activate Mason if you haven't already
dart pub global activate mason_cli

# Add the brick to your project
mason add arsync_firebase_auth
```

## 🔧 Usage

```bash
# Navigate to your Flutter project directory
cd your_flutter_project

# Run the brick and select your desired authentication methods
mason make arsync_firebase_auth
```

You'll be prompted to select which authentication providers you want to include in your project. The brick will automatically install the required packages based on your selections.

## ⚙️ Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `signup` | Include email signup provider | true |
| `login` | Include email login provider | true |
| `login_with_google` | Include Google login provider | true |
| `login_with_apple` | Include Apple login provider | true |
| `phone_auth` | Include phone authentication provider | false |
| `passwordless_email` | Include passwordless email login provider | false |
| `forgot_password` | Include forgot password functionality | true |
| `email_verification` | Include email verification provider | true |
| `change_password` | Include change password provider | true |

Note: The following components are always generated regardless of your selections:
- `auth_base_notifier.dart`: Base class that all providers extend
- `auth_loading_provider.dart`: Central loading state provider
- `delete_account_provider.dart`: Account deletion functionality
- `log_out_provider.dart`: Logout functionality

## 📄 Generated Files Structure

The brick generates files that follow this structure:

```
lib/
├── providers/
│   ├── auth/
│   │   ├── auth_base_notifier.dart                   # Base class
│   │   ├── auth_loading_provider.dart                # Loading
│   │   ├── delete_account_provider.dart              # Account deletion
│   │   ├── log_out_provider.dart                     # Logout functionality
│   │   ├── sign_up_provider.dart                     # Email signup
│   │   ├── login_with_email_provider.dart            # Email login
│   │   ├── login_with_google_provider.dart           # Google login
│   │   ├── login_with_apple_provider.dart            # Apple login
│   │   ├── login_with_phone_provider.dart            # Phone authentication
│   │   ├── passwordless_email_provider.dart          # Email magic links
│   │   ├── forgot_password_provider.dart             # Password reset
│   │   ├── verify_email_provider.dart                # Email verification
│   │   └── change_password_provider.dart             # Password change
│   ├── firebase_messaging_provider.dart              # FCM token management
│   └── firestore_provider.dart                       # User data management
```

## 🧩 Project Dependencies

The brick automatically installs these packages based on your selections:

### Core Dependencies (Always Installed)
- `firebase_auth`: Firebase Authentication
- `cloud_firestore`: Firebase Firestore
- `firebase_messaging`: Firebase Cloud Messaging
- `flutter_local_notifications`: Local notifications

### Conditional Dependencies
- `google_sign_in`: Installed if Google Sign-In is enabled
- `sign_in_with_apple`: Installed if Apple Sign-In is enabled

## 🏗️ Required Project Structure

The generated code assumes the following project structure:

```
lib/
├── models/
│   └── app_user.dart                    # Your AppUser model with userid field
├── providers/
│   ├── alert_provider.dart              # For showing alerts and snackbars
│   ├── app_user_provider.dart           # For managing the current user
│   └── router_provider.dart             # For navigation
├── screens/
│   └── auth/                            # Your authentication screens
│       └── login_screen.dart            # Login screen with defined route name
└── utils/
    ├── app_colors.dart                  # App colors
    ├── logging_extensions.dart          # Extensions for logging
    └── utils.dart                       # Other utilities
```


## 🧪 Usage Examples

### Authentication State Observer

### Login with Email and Password

```dart
ElevatedButton(
  onPressed: () {
          ref.read(loginWithEmailProvider.notifier).loginWithEmailPassword(
                emailController.text,
                passwordController.text,
              );
        },
  child: ref.watch(authLoadingProvider)
      ? const CircularProgressIndicator()
      : const Text('Login'),
)
```

### Sign Up with Email

```dart
ElevatedButton(
  onPressed: () {
          final newUser = AppUser(
            email: emailController.text,
            name: nameController.text,
          );
          
          ref.read(signupWithEmailPasswordProvider.notifier).signup(
                newUser,
                passwordController.text,
              );
        },
  child: ref.watch(authLoadingProvider)
      ? const CircularProgressIndicator()
      : const Text('Create Account'),
)
```

### Google Sign-In Button

```dart
IconButton(
  onPressed: ref.watch(authLoadingProvider)
      ? null
      : () => ref.read(loginWithGoogleProvider.notifier).signInWithGoogle(),
  icon: Image.asset('assets/google_icon.png', width: 24),
)
```

### Sign Out

```dart
IconButton(
  onPressed: () => ref.read(logoutProvider.notifier).logout(),
  icon: Icon(Icons.logout),
)
```

## 🔄 Customization

### Firebase Project Setup

Before using this brick, ensure you have:

1. Created a Firebase project
2. Added your Flutter app to the Firebase project
3. Downloaded and configured the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files
4. Added the Firebase SDK dependencies to your project

### Social Authentication Setup

#### Google Sign-In
- Add your SHA-1 fingerprint to your Firebase project
- For Android: Ensure your `google-services.json` is properly configured
- For iOS: Update your `Info.plist` with the required URL schemes

#### Apple Sign-In
- Configure your Apple Developer account
- Create an App ID with Sign In with Apple capability
- For iOS: Add the Sign In with Apple capability in Xcode
- For Android: Create a Service ID in your Apple Developer account

### Phone Authentication
- Enable Phone Authentication in your Firebase Console
- Test with real phone numbers (Firebase may limit emulator verification)
- Set up reCAPTCHA verification for web platforms

## ⚠️ Troubleshooting

### Common Issues

1. **Firebase Implementation Issues**
   - Solution: Ensure you've initialized Firebase in your app's `main.dart`:
     ```dart
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     ```

2. **Google Sign-In Problems**
   - Solution: Check your SHA-1 fingerprint in Firebase console and verify the configuration in `google-services.json`

3. **Missing Riverpod Providers**
   - Solution: Make sure you've wrapped your app with `ProviderScope`:
     ```dart
     void main() {
       runApp(ProviderScope(child: MyApp()));
     }
     ```



## Author

**Atif Siddiqui**
- Email: itsatifsiddiqui@gmail.com
- GitHub: [itsatifsiddiqui](https://github.com/itsatifsiddiqui)
- LinkedIn: [Atif Siddiqui](https://www.linkedin.com/in/atif-siddiqui-213a2217b/)


## About Arsync Solutions

[Arsync Solutions](https://arsyncsolutions.com), We build Flutter apps for iOS, Android, and the web.