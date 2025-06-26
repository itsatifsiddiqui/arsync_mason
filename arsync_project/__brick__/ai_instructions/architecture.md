# Instructions for Flutter Architecture

You are a Flutter developer following a strict 4-layer architecture. This document contains ALL critical rules you MUST follow without exception.

## Core Architecture Overview

This project uses a 4-layer architecture to prevent spaghetti code:

1. **Presentation Layer** (`screens/` and `widgets/`) - Dumb UI that only displays and reports user actions via callbacks
2. **ViewModel Layer** (`providers/`) - Smart coordinators managing state and business logic  
3. **Model Layer** (`models/`) - Immutable data structures with Freezed and Json Serialization
4. **Repository Layer** (`repositories/`) - Data access abstraction

## CRITICAL LAYER COMMUNICATION RULES

### ✅ ALLOWED
- Presentation → ViewModel
- ViewModel → Repository
- ViewModel → Model
- Repository <- Model

### ❌ FORBIDDEN
- Presentation → Repository
- Presentation → Direct Data Sources (Firebase/API)
- Model → Any other layer
- BuildContext in ViewModels
- Business logic in Widgets

## 1. PRESENTATION LAYER - Complete Rules

### Golden Rule: Widgets Must Be DUMB
- Shows what it's told
- Doesn't decide what to display
- Doesn't fetch data
- Just displays and reports user actions
- Create small, composable widgets over large monolithic ones
- Use flex values in Rows/Columns for responsive design
- Define theme properties in MaterialApp's theme rather than hardcoding

### Code Style
- Use log from logging_extensions.dart for logging (not print or debugPrint)
- Follow Flutter's linting rules defined in analysis_options.yaml


### Widget Types (USE ONLY THESE)

#### StatelessWidget - Simple Display
```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      onTap: onTap,
      child: Column(
        children: [
          Text(product.name),
          PrimaryButton(
            text: 'Add to Cart',
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
```

#### ConsumerWidget - Watch ViewModels
```dart
class ProductListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      body: productsState.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ProductCard(
            product: products[index],
            onTap: () => ref.read(productsProvider.notifier).addToCart(products[index].id),
          ),
        ),
        loading: () => PrimaryProgressIndicator(),
        error: (error, stack) => PrimaryErrorWidget(
          error: error,
          providerToRefresh: productsProvider,
        ),
      ),
    );
  }
}
```

#### HookConsumerWidget - Local UI State + ViewModels
```dart
class LoginScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final formKey = GlobalObjectKey<FormState>(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            PrimaryTextField(
              controller: emailController,
              title: 'Email',
              validator: Validators.emailValidator,
            ),
            PrimaryTextField(
              controller: passwordController,
              title: 'Password',
              validator: Validators.passwordValidator,
              obscureText: !isPasswordVisible.value,
            ),
            PrimaryButton(
              text: 'Login',
              isLoading: authState.isLoading,
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                ref.read(authProvider.notifier).login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### MANDATORY Design System Widgets
- `PrimaryButton` NOT `ElevatedButton`
- `PrimaryTextField` NOT `TextField`
- `PrimaryCard` NOT `Card`
- `PrimaryProgressIndicator` NOT `CircularProgressIndicator`
- `PrimaryErrorWidget` for errors
- `PrimaryInfoWidget` for info
- `PrimarySheet` for bottom sheets

### MANDATORY Color and Image Guidelines
- **Colors**: NEVER hardcode colors. Always use colors from `AppTheme` class (e.g., `AppTheme.primaryLight`, `context.theme.primaryColor`)
- **Images**: NEVER hardcode image paths. Always define image paths in `lib/utils/images.dart` and reference them (e.g., `Images.logo`)

### Breaking Complex Screens - Use Private Widgets NOT Methods
```dart
// ✅ CORRECT
class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(title: Text('Products'));
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// ❌ WRONG
Widget _buildAppBar() => AppBar(title: Text('Products'));
```

## 2. VIEWMODEL LAYER - Complete Rules

### ONLY Use These Provider Types

#### NotifierProvider - Synchronous State
```dart
final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}
```

#### AsyncNotifierProvider - Asynchronous Operations
```dart
final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, AppUser>(() {
  return UserProfileNotifier();
});

class UserProfileNotifier extends AsyncNotifier<AppUser> {
  @override
  Future<AppUser> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.read(userRepositoryProvider).getUserProfile(userId);
  }

  Future<void> updateProfile(AppUser updatedUser) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(userRepositoryProvider).updateProfile(updatedUser);
      state = AsyncValue.data(result);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      ref.showExceptionSheet(e);
    }
  }
}
```

#### StreamNotifierProvider - Real-time Streams
```dart
final messagesProvider = StreamNotifierProvider<MessagesNotifier, List<Message>>(() {
  return MessagesNotifier();
});

class MessagesNotifier extends StreamNotifier<List<Message>> {
  @override
  Stream<List<Message>> build() {
    final chatId = ref.watch(currentChatIdProvider);
    return ref.read(messageRepositoryProvider).getMessagesStream(chatId);
  }

  Future<void> sendMessage(String content) async {
    try {
      final chatId = ref.read(currentChatIdProvider);
      await ref.read(messageRepositoryProvider).sendMessage(chatId, content);
    } catch (e, s) {
      ref.showExceptionSheet(e);
    }
  }
}
```

#### StateProvider - Simple UI State ONLY
```dart
// ✅ ALLOWED: Simple UI state
final selectedTabProvider = StateProvider<int>((ref) => 0);
final searchQueryProvider = StateProvider<String>((ref) => '');
final isPasswordVisibleProvider = StateProvider<bool>((ref) => false);

// ❌ FORBIDDEN: Complex objects
final userProvider = StateProvider<User>((ref) => User.empty()); // NEVER!
```

#### FutureProvider/StreamProvider - Read-Only Data
```dart
// Read-only data fetching
final userProfileProvider = FutureProvider.family<User, String>((ref, userId) async {
  return ref.read(userRepositoryProvider).getUserById(userId);
});

// Read-only stream
final messagesProvider = StreamProvider.family<List<Message>, String>((ref, chatId) {
  return ref.read(messageRepositoryProvider).getMessagesStream(chatId);
});
```

### ❌ NEVER USE
- StateNotifierProvider (deprecated)
- ChangeNotifierProvider

### Error Handling - ALWAYS Use ref.showExceptionSheet(e)
```dart
Future<void> someAction() async {
  state = const AsyncValue.loading();
  try {
    final result = await ref.read(repository).getData();
    state = AsyncValue.data(result);
  } catch (e, s) {
    state = AsyncValue.error(e, s);
    ref.showExceptionSheet(e); // ALWAYS do this
  }
}
```

## Recommended Project Structure

```
lib/
├── main.dart                    # App entry point
├── my_app.dart                  # MyApp widget
├── app_theme.dart               # App theme configuration
├── firebase_options.dart        # Firebase configuration
│
├── hooks/                       # Custom React hooks
│   ├── keyboard_visibility.dart
│   └── periodic_refresh.dart
│
├── models/                      # 📦 MODEL LAYER
│   ├── user/
│   │   ├── app_user.dart
│   │   ├── app_user.freezed.dart
│   │   └── app_user.g.dart
│   ├── product/
│   │   ├── state/
│   │   │   ├── products_state.dart
│   │   │   └── search_state.dart
│   │   ├── product.dart
│   │   ├── product.freezed.dart
│   │   └── product.g.dart
│   ├── order/
│   │   ├── order.dart
│   │   ├── cart.dart
│   │   └── order_status.dart
│   └── common/
│       ├── app_config.dart
│       └── api_response.dart
│
├── providers/                   # 🧠 VIEWMODEL LAYER
│   ├── auth/
│   │   ├── auth_provider.dart
│   │   ├── login_provider.dart
│   │   └── signup_provider.dart
│   ├── user/
│   │   ├── app_user_provider.dart
│   │   └── user_profile_provider.dart
│   ├── product/
│   │   ├── products_provider.dart
│   │   └── product_search_provider.dart
│   ├── order/
│   │   ├── cart_provider.dart
│   │   └── checkout_provider.dart
│   ├── core/
│   │   ├── router_provider.dart
│   │   ├── theme_provider.dart
│   │   ├── shared_preferences_provider.dart
│   │   └── base_provider.dart
│   └── services/
│       ├── firebase_messaging_provider.dart
│       └── location_provider.dart
│
├── repositories/                # 🗄️ REPOSITORY LAYER
│   ├── auth_repository.dart
│   ├── user_repository.dart
│   ├── product_repository.dart
│   ├── order_repository.dart
│   └── message_repository.dart
│
├── screens/                     # 🎨 PRESENTATION LAYER
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── widgets/
│   │       ├── auth_header_widget.dart
│   │       └── social_login_buttons.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── tabs_view/
│   │   ├── tabs_view.dart
│   │   ├── home_tab/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   ├── profile_tab/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   └── widgets/
│   │   └── messages_tab/
│   │       ├── messages_screen.dart
│   │       ├── chat_screen.dart
│   │       └── widgets/
│   └── products/
│       ├── products_screen.dart
│       ├── product_details_screen.dart
│       ├── product_search_screen.dart
│       └── widgets/
│           ├── product_card.dart
│           └── product_filter.dart
│
├── widgets/                     # 🎨 SHARED UI COMPONENTS
│   ├── primary_button.dart
│   ├── primary_card.dart
│   ├── primary_text_field.dart
│   ├── primary_error_widget.dart
│   ├── primary_loading_indicator.dart
│   ├── primary_progress_indicator.dart
│   ├── primary_sheet.dart
│   ├── primary_info_widget.dart
│   ├── primary_titled_drop_down.dart
│   └── measure_size.dart
│
├── utils/                       # 🔧 UTILITIES
│   ├── constants.dart
│   ├── app_colors.dart
│   ├── validators.dart
│   ├── extensions.dart
│   ├── utils.dart
│   ├── images.dart
│   ├── debouncer.dart
│   ├── exception_toolkit.dart
│   ├── alert_extensions.dart
│   └── ref_extensions.dart
│
└── services/                    # 🔧 EXTERNAL SERVICES
    ├── analytics_service.dart
    ├── location_service.dart
    ├── permissions_service.dart
    └── video_service.dart

```