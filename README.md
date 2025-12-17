# Flutter Sample Architecture

A clean architecture Flutter project demonstrating best practices with feature-based structure, BLoC state management, and comprehensive configuration management.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Flavor Configuration](#flavor-configuration)
- [App Preferences (AppPref)](#app-preferences-apppref)
- [Use Cases](#use-cases)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Project Structure](#project-structure)

## ✨ Features

- 🏗️ **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- 🎨 **Flavor Support** - Multiple build configurations (development, staging, production)
- 💾 **Local Storage** - Shared preferences wrapper with AppPref
- 🔄 **State Management** - BLoC/Cubit pattern with selectors
- 🧩 **Use Cases** - Functional programming with Either type for error handling
- 🧭 **Navigation** - GoRouter for declarative routing
- 🎯 **Type Safety** - Freezed for immutable classes, Equatable for value equality

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

```
lib/
├── core/                    # Shared utilities and configurations
│   ├── config/             # App configuration and flavors
│   ├── constants/          # App constants and enums
│   ├── storage/            # Local storage (AppPref)
│   ├── network/            # API client and services
│   ├── router/             # Navigation configuration
│   └── theme/              # App theming
│
└── features/               # Feature modules
    └── auth/               # Authentication feature
        ├── data/           # Data layer (repositories, data sources)
        ├── domain/         # Domain layer (entities, use cases)
        └── presentation/   # Presentation layer (UI, BLoC)
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.10.0 or higher)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd fluttersampleachitecture
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code (for freezed classes)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## 🎨 Flavor Configuration

The app supports multiple build flavors for different environments.

### Available Flavors

- **development** - Development environment (default)
- **staging** - Staging environment
- **production** - Production environment

### Running with Flavors

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=APP_FLAVOR=staging

# Production
flutter run --dart-define=APP_FLAVOR=production

# With custom API URL
flutter run --dart-define=APP_FLAVOR=staging --dart-define=API_BASE_URL=https://custom-api.com
```

### Building with Flavors

```bash
# Android APK
flutter build apk --dart-define=APP_FLAVOR=production

# Android App Bundle
flutter build appbundle --dart-define=APP_FLAVOR=production

# iOS
flutter build ios --dart-define=APP_FLAVOR=production
```

### Using Flavors in Code

```dart
import 'package:fluttersampleachitecture/core/config/app_config.dart';

// Get current flavor
final flavor = AppConfig.currentFlavor;
print(flavor.name); // "Development", "Staging", or "Production"

// Get API URL
final apiUrl = AppConfig.getBaseUrl();

// Get app name
final appName = AppConfig.appName;

// Check if logging is enabled
if (AppConfig.enableLogging) {
  print('Debug message');
}
```

## 💾 App Preferences (AppPref)

`AppPref` provides a convenient interface for managing local storage using SharedPreferences.

### Initialization

AppPref is automatically initialized in `main.dart`. No manual initialization needed.

### Authentication Methods

```dart
import 'package:fluttersampleachitecture/core/storage/app_pref.dart';

// Save authentication token
await AppPref.setToken('your_jwt_token');

// Get authentication token
String? token = AppPref.getToken();

// Check if user is authenticated
bool isAuth = AppPref.isAuthenticated();

// Save refresh token
await AppPref.setRefreshToken('refresh_token');

// Save user ID
await AppPref.setUserId('user123');

// Clear all authentication data
await AppPref.clearAuth();
```

### Theme Management

```dart
// Save theme mode
await AppPref.setThemeMode('dark'); // 'light', 'dark', or 'system'

// Get theme mode
String themeMode = AppPref.getThemeMode(); // Returns 'system' by default
```

### Generic Storage Methods

```dart
// String
await AppPref.setString('key', 'value');
String? value = AppPref.getString('key');
String defaultValue = AppPref.getStringOrDefault('key', 'default');

// Integer
await AppPref.setInt('count', 42);
int? count = AppPref.getInt('count');
int defaultCount = AppPref.getIntOrDefault('count', 0);

// Boolean
await AppPref.setBool('isEnabled', true);
bool? isEnabled = AppPref.getBool('isEnabled');
bool defaultBool = AppPref.getBoolOrDefault('isEnabled', false);

// Double
await AppPref.setDouble('price', 99.99);
double? price = AppPref.getDouble('price');

// String List
await AppPref.setStringList('tags', ['tag1', 'tag2']);
List<String>? tags = AppPref.getStringList('tags');
```

### Utility Methods

```dart
// Remove a specific key
await AppPref.remove('key');

// Clear all preferences
await AppPref.clear();

// Check if key exists
bool exists = AppPref.containsKey('key');

// Get all keys
Set<String> keys = AppPref.getKeys();
```

## 🎯 Use Cases

Use cases follow a functional programming pattern with `Either<ErrorMsg, T>` for error handling.

### Creating a Use Case

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';

class MyUseCase extends UseCase<MyEntity, MyParams> {
  final MyRepository repository;

  MyUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
    return await repository.doSomething(params: params);
  }
}

class MyParams extends Equatable {
  final String data;

  const MyParams({required this.data});

  @override
  List<Object?> get props => [data];
}
```

### Using a Use Case in Cubit

```dart
final result = await myUseCase.call(MyParams(data: 'value'));

result.fold(
  // Left: Error
  (error) {
    emit(state.copyWith(status: StateStatus.error));
    ErrorSnackBar.show(context, error);
  },
  // Right: Success
  (response) {
    emit(state.copyWith(
      status: StateStatus.success,
      data: response,
    ));
  },
);
```

## 🔄 State Management

The project uses **BLoC/Cubit** for state management with **BlocSelector** for optimized rebuilds.

### Creating a Cubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'state_status.dart';

class MyCubit extends Cubit<MyState> {
  final MyUseCase useCase;

  MyCubit(this.useCase) : super(const MyState());

  Future<void> doSomething() async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await useCase.call(MyParams());

    result.fold(
      (error) => emit(state.copyWith(status: StateStatus.error)),
      (data) => emit(state.copyWith(
        status: StateStatus.success,
        data: data,
      )),
    );
  }
}
```

### Using BlocSelector in UI

```dart
BlocSelector<MyCubit, MyState, StateStatus>(
  selector: (state) => state.status,
  builder: (context, status) {
    if (status == StateStatus.loading) {
      return const CircularProgressIndicator();
    }
    return YourWidget();
  },
)
```

### State Status Enum

```dart
enum StateStatus {
  idle,      // Initial state
  loading,   // Loading state
  success,   // Success state
  error,     // Error state
}
```

## 🧭 Navigation

Navigation is handled using **GoRouter**.

### Defining Routes

```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
```

### Navigation Methods

```dart
// Navigate to a route
context.push(AppRoutes.home);

// Navigate with data
context.push(AppRoutes.details, extra: {'id': 123});

// Replace current route
context.go(AppRoutes.home);

// Pop current route
context.pop();

// Pop with result
context.pop('result');
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/              # App configuration
│   │   ├── app_config.dart
│   │   └── flavor_setup_helper.dart
│   ├── constants/           # Constants and enums
│   │   ├── app_constants.dart
│   │   ├── app_enums.dart
│   │   ├── app_flavor.dart
│   │   └── app_routes.dart
│   ├── storage/             # Local storage
│   │   ├── app_pref.dart
│   │   └── shared_preferences_service.dart
│   ├── network/             # Network layer
│   │   ├── api_client.dart
│   │   └── api_config.dart
│   ├── router/              # Navigation
│   │   └── app_router.dart
│   └── theme/               # Theming
│       └── app_theme.dart
│
└── features/
    └── auth/                # Authentication feature
        ├── data/
        │   ├── data_sources/
        │   ├── repositories/
        │   └── models/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── use_cases/
        └── presentation/
            ├── manager/      # BLoC/Cubit
            ├── pages/        # UI Pages
            └── widgets/      # Reusable widgets
```

## 🔧 Code Generation

The project uses **Freezed** for immutable classes. After modifying state classes, regenerate:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📝 Best Practices

1. **Use Cases**: Always use use cases for business logic
2. **Error Handling**: Use `Either<ErrorMsg, T>` pattern
3. **State Management**: Use `BlocSelector` for optimized rebuilds
4. **Storage**: Use `AppPref` for all local storage needs
5. **Flavors**: Always specify flavor when building for production
6. **Navigation**: Use `AppRoutes` constants for route paths

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Dependencies

- **flutter_bloc** - State management
- **dartz** - Functional programming (Either type)
- **go_router** - Navigation
- **shared_preferences** - Local storage
- **dio** - HTTP client
- **freezed** - Immutable classes
- **equatable** - Value equality

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and ensure they pass
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

For more details, check the inline documentation in the codebase.
