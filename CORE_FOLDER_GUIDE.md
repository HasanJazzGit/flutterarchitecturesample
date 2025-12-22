# Core Folder Guide

## 📋 Table of Contents

1. [Overview](#overview)
2. [Core Folder Structure](#core-folder-structure)
3. [When to Add to Core](#when-to-add-to-core)
4. [Detailed Guide for Each Folder](#detailed-guide-for-each-folder)
5. [How to Add New Components](#how-to-add-new-components)
6. [Best Practices](#best-practices)

---

## 🎯 Overview

The `core/` folder contains **shared, reusable components** that are used across multiple features. These are app-wide utilities, configurations, and infrastructure that don't belong to any specific feature.

### Key Principles:

1. **Shared Only**: Only add components that are used by multiple features
2. **No Business Logic**: Core should not contain feature-specific business logic
3. **Reusable**: Components should be generic and reusable
4. **Well-Documented**: All core components should be well-documented

---

## 📁 Core Folder Structure

```
lib/core/
├── app/                    # App-level state management
│   ├── app_cubit.dart
│   └── app_state.dart
│
├── config/                 # App configuration
│   ├── app_config.dart
│   ├── flavor_setup_helper.dart
│   └── flavor_commands.md
│
├── constants/              # App constants
│   ├── app_constants.dart
│   ├── app_enums.dart
│   ├── app_flavor.dart
│   ├── app_sizes.dart
│   ├── app_strings.dart
│   └── mockapi_responses.dart
│
├── di/                     # Dependency injection
│   ├── dependency_injection.dart
│   ├── di_export.dart
│   └── DI_TEMPLATE.md
│
├── enums/                  # Shared enums
│   └── state_status.dart
│
├── failure/                # Exception types
│   └── exceptions.dart
│
├── functional/             # Functional programming utilities
│   ├── either.dart
│   ├── failure.dart
│   └── functional_export.dart
│
├── l10n/                   # Localization files
│   ├── app_en.arb
│   ├── app_ur.arb
│   └── app_localizations.dart
│
├── localization/           # Localization service
│   └── app_localization_service.dart
│
├── network/                # Network layer
│   ├── api_client.dart
│   ├── api_config.dart
│   ├── api_logger_interceptor.dart
│   └── app_urls.dart
│
├── router/                 # Navigation
│   ├── app_router.dart
│   └── app_routes.dart
│
├── storage/                # Local storage
│   ├── app_pref.dart
│   ├── app_pref_impl.dart
│   ├── app_pref_keys.dart
│   └── app_pref_export.dart
│
├── theme/                  # Theming
│   ├── app_colors.dart
│   └── app_theme.dart
│
├── use_case/               # Base use case
│   └── base_use_case.dart
│
├── utils/                  # Utilities
│   ├── error_handler.dart
│   ├── extensions.dart
│   ├── extensions_export.dart
│   ├── flavor_helper.dart
│   ├── number_extensions.dart
│   ├── size_extensions.dart
│   ├── text_extensions.dart
│   └── validators.dart
│
└── widgets/                 # Reusable widgets
    ├── app_shimmer.dart
    ├── widgets_export.dart
    └── SHIMMER.md
```

---

## ✅ When to Add to Core

### ✅ Add to Core When:

1. **Used by Multiple Features**: Component is used by 2+ features
2. **App-Wide Configuration**: App-level settings, configs, constants
3. **Infrastructure**: Network, storage, routing, theming
4. **Shared Utilities**: Extensions, validators, helpers used everywhere
5. **Base Classes**: Base use cases, base widgets, base services

### ❌ Don't Add to Core When:

1. **Feature-Specific**: Only used by one feature (put in feature folder)
2. **Business Logic**: Feature-specific business rules
3. **UI Components**: Feature-specific UI (put in feature/presentation/widgets)
4. **Temporary Code**: Experimental or temporary code

---

## 📚 Detailed Guide for Each Folder

### 1. `app/` - App-Level State Management

**Purpose:** Manages app-wide state (theme, locale, app lifecycle)

**Files:**
- `app_cubit.dart` - Cubit for app-level state
- `app_state.dart` - State class for app-level data

**When to Add:**
- New app-wide state (e.g., app version, onboarding status)
- Global settings that affect entire app

**Example:**
```dart
// app/app_state.dart
class AppState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isOnboardingCompleted;
  
  // Add new app-wide state here
}
```

---

### 2. `config/` - App Configuration

**Purpose:** App configuration, flavors, environment setup

**Files:**
- `app_config.dart` - Main config class
- `flavor_setup_helper.dart` - Flavor initialization
- `flavor_commands.md` - Flavor commands documentation

**When to Add:**
- New flavor configurations
- New environment variables
- New config helpers

**Example:**
```dart
// config/app_config.dart
class AppConfig {
  // Add new config getters here
  static String get apiKey => currentFlavor.apiKey;
  static bool get enableAnalytics => currentFlavor.enableAnalytics;
}
```

---

### 3. `constants/` - App Constants

**Purpose:** Centralized constants, enums, strings, sizes

**Files:**
- `app_constants.dart` - General constants (timeouts, limits, etc.)
- `app_enums.dart` - App-wide enums
- `app_flavor.dart` - Flavor definitions
- `app_sizes.dart` - Size constants (padding, margins, etc.)
- `app_strings.dart` - String constants
- `mockapi_responses.dart` - Mock API responses

**When to Add:**
- New app-wide constants
- New enums used by multiple features
- New size constants
- New string constants

**How to Add Constants:**

#### Adding to `app_constants.dart`:
```dart
class AppConstants {
  // ... existing constants
  
  // Add new constants here
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const Duration cacheExpiry = Duration(hours: 24);
}
```

#### Adding to `app_enums.dart`:
```dart
/// New enum for app-wide use
enum FileType {
  image,
  video,
  document,
  audio;
  
  String get extension {
    switch (this) {
      case FileType.image:
        return '.jpg';
      case FileType.video:
        return '.mp4';
      case FileType.document:
        return '.pdf';
      case FileType.audio:
        return '.mp3';
    }
  }
}
```

#### Adding to `app_sizes.dart`:
```dart
class AppSizes {
  // ... existing sizes
  
  // Add new size constants
  static const double avatarSize = 48.0;
  static const double avatarSizeLarge = 96.0;
  static const double thumbnailSize = 120.0;
}
```

#### Adding to `app_strings.dart`:
```dart
class AppStrings {
  // ... existing strings
  
  // Add new string constants
  static const String upload = 'Upload';
  static const String download = 'Download';
  static const String fileTooLarge = 'File size exceeds limit';
}
```

---

### 4. `di/` - Dependency Injection

**Purpose:** Centralized dependency injection setup

**Files:**
- `dependency_injection.dart` - Main DI setup
- `di_export.dart` - DI exports
- `DI_TEMPLATE.md` - DI template documentation

**When to Add:**
- New core services that need DI
- New shared dependencies

**How to Add:**
See `DI_TEMPLATE.md` for detailed guide.

**Example:**
```dart
// di/dependency_injection.dart
Future<void> _initCore() async {
  // ... existing registrations
  
  // Register new core service
  sl.registerLazySingleton<NewService>(
    () => NewServiceImpl(),
  );
}
```

---

### 5. `enums/` - Shared Enums

**Purpose:** Enums used across multiple features

**Files:**
- `state_status.dart` - State status enum (idle, loading, success, error)

**When to Add:**
- New enums used by multiple features

**How to Add:**
```dart
// enums/upload_status.dart
enum UploadStatus {
  idle,
  uploading,
  success,
  failed,
  cancelled;
  
  bool get isUploading => this == UploadStatus.uploading;
  bool get isCompleted => this == UploadStatus.success || this == UploadStatus.failed;
}
```

**Then export in a new file or add to existing enum file.**

---

### 6. `failure/` - Exception Types

**Purpose:** Custom exception types

**Files:**
- `exceptions.dart` - Exception type definitions

**When to Add:**
- New exception types used across features

**How to Add:**
```dart
// failure/exceptions.dart
// Add new exception types
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  
  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
  
  @override
  String toString() => message;
}
```

---

### 7. `functional/` - Functional Programming

**Purpose:** Functional programming utilities (Either, Failure)

**Files:**
- `either.dart` - Either type for error handling
- `failure.dart` - Failure classes
- `functional_export.dart` - Exports

**When to Add:**
- New functional programming utilities
- New failure types

**How to Add:**
```dart
// functional/failure.dart
// Add new failure type
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
  });
  
  @override
  String toString() => 'TimeoutFailure: $message';
}
```

---

### 8. `l10n/` - Localization Files

**Purpose:** Localization resource files

**Files:**
- `app_en.arb` - English translations
- `app_ur.arb` - Urdu translations
- `app_localizations.dart` - Generated localization class

**When to Add:**
- New translations
- New languages

**How to Add:**
```json
// l10n/app_en.arb
{
  "@appName": {
    "description": "Application name",
    "type": "String"
  },
  "appName": "My App",
  
  // Add new translations
  "@uploadFile": {},
  "uploadFile": "Upload File",
  
  "@fileSize": {
    "placeholders": {
      "size": {
        "type": "String"
      }
    }
  },
  "fileSize": "File size: {size}",
  "@fileSize.size": {}
}
```

---

### 9. `localization/` - Localization Service

**Purpose:** Localization service for managing app language

**Files:**
- `app_localization_service.dart` - Localization service

**When to Add:**
- New localization methods
- New language switching logic

---

### 10. `network/` - Network Layer

**Purpose:** API client, network configuration, endpoints

**Files:**
- `api_client.dart` - HTTP client wrapper
- `api_config.dart` - API configuration
- `api_logger_interceptor.dart` - API logging interceptor
- `app_urls.dart` - API endpoint URLs

**When to Add:**
- New API endpoints
- New network interceptors
- New network utilities

**How to Add API Endpoints:**
```dart
// network/app_urls.dart
class AppUrls {
  // ... existing URLs
  
  // Add new endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String userPosts(String userId) => '/users/$userId/posts';
}
```

**How to Add Network Interceptor:**
```dart
// network/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token, modify headers, etc.
    super.onRequest(options, handler);
  }
}

// Then add to ApiClient in api_client.dart
```

---

### 11. `router/` - Navigation

**Purpose:** App routing configuration

**Files:**
- `app_router.dart` - GoRouter configuration
- `app_routes.dart` - Route constants

**When to Add:**
- New routes
- New route guards
- New navigation utilities

**How to Add Routes:**
```dart
// router/app_routes.dart
class AppRoutes {
  // ... existing routes
  
  // Add new routes
  static const String users = 'users';
  static const String userDetails = 'users/:id';
  static const String userSettings = 'users/:id/settings';
}

// router/app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.users),
  name: AppRoutes.users,
  builder: (context, state) => const UsersPage(),
),
GoRoute(
  path: AppRoutes.path(AppRoutes.userDetails),
  name: AppRoutes.userDetails,
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return UserDetailsPage(userId: id);
  },
),
```

---

### 12. `storage/` - Local Storage

**Purpose:** App preferences, local storage

**Files:**
- `app_pref.dart` - Abstract preferences interface
- `app_pref_impl.dart` - SharedPreferences implementation
- `app_pref_keys.dart` - Storage keys
- `app_pref_export.dart` - Exports

**When to Add:**
- New preference keys
- New storage methods

**How to Add:**
See `STORAGE.md` for detailed guide.

**Quick Example:**
```dart
// preference/app_pref_keys.dart
class AppPrefKeys {
  // ... existing keys
  
  // Add new keys
  static const String userProfile = 'user_profile';
  static const String lastSyncTime = 'last_sync_time';
}

// preference/app_pref.dart
abstract class AppPref {
  // ... existing methods
  
  // Add new methods
  Future<bool> setUserProfile(String profile);
  String getUserProfile();
  Future<bool> setLastSyncTime(DateTime time);
  DateTime? getLastSyncTime();
}

// preference/app_pref_impl.dart
class AppPrefImpl implements AppPref {
  // Implement new methods
  @override
  Future<bool> setUserProfile(String profile) async {
    // Implementation
  }
  
  // ... etc
}
```

---

### 13. `theme/` - Theming

**Purpose:** App theming, colors, Material theme

**Files:**
- `app_colors.dart` - App color definitions
- `app_theme.dart` - Material theme configuration

**When to Add:**
- New colors
- New theme configurations
- New theme extensions

**How to Add Colors:**
```dart
// theme/app__theme_colors.dart
class AppColors extends ThemeExtension<AppColors> {
  // ... existing colors
  
  // Add new colors
  final Color? accent;
  final Color? surfaceVariant;
  
  const AppColors({
    // ... existing parameters
    this.accent,
    this.surfaceVariant,
  });
  
  // Update light and dark themes
  static const AppColors light = AppColors(
    // ... existing colors
    accent: Color(0xFF00BCD4),
    surfaceVariant: Color(0xFFE0E0E0),
  );
  
  static const AppColors dark = AppColors(
    // ... existing colors
    accent: Color(0xFF00BCD4),
    surfaceVariant: Color(0xFF424242),
  );
  
  // Update copyWith and lerp methods
}
```

---

### 14. `use_case/` - Base Use Case

**Purpose:** Base use case interface

**Files:**
- `base_use_case.dart` - Base use case abstract class

**When to Add:**
- New base use case types (if needed)

**Example:**
```dart
// use_case/base_use_case.dart
// Add new base use case type if needed
abstract class UseCaseWithCache<T, Params> extends UseCase<T, Params> {
  Future<Either<ErrorMsg, T>> callWithCache(Params params);
}
```

---

### 15. `utils/` - Utilities

**Purpose:** Utility functions, extensions, helpers

**Files:**
- `error_handler.dart` - Error handling utilities
- `extensions.dart` - String, DateTime extensions
- `extensions_export.dart` - Extension exports
- `flavor_helper.dart` - Flavor helper functions
- `number_extensions.dart` - Number extensions
- `size_extensions.dart` - Size/MediaQuery extensions
- `text_extensions.dart` - Text/TextStyle extensions
- `validators.dart` - Validation functions

**When to Add:**
- New utility functions
- New extensions
- New validators
- New helpers

**How to Add Extensions:**
```dart
// utils/date_extensions.dart
extension DateExtension on DateTime {
  /// Get relative time string (e.g., "2 hours ago")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

// Then export in extensions_export.dart
export 'date_extensions.dart';
```

**How to Add Validators:**
```dart
// utils/validators.dart
class Validators {
  // ... existing validators
  
  // Add new validators
  static String? url(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'URL is required' : null;
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  static String? fileSize(int? sizeInBytes, {int maxSizeInMB = 10}) {
    if (sizeInBytes == null) return 'File size is required';
    
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    if (sizeInBytes > maxSizeInBytes) {
      return 'File size must be less than $maxSizeInMB MB';
    }
    
    return null;
  }
}
```

**How to Add Helpers:**
```dart
// utils/date_helper.dart
class DateHelper {
  /// Format date to display string
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    // Implementation
  }
  
  /// Parse date string
  static DateTime? parseDate(String dateString) {
    // Implementation
  }
  
  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
```

---

### 16. `widgets/` - Reusable Widgets

**Purpose:** Reusable widgets used across features

**Files:**
- `app_shimmer.dart` - Shimmer loading widget
- `widgets_export.dart` - Widget exports
- `SHIMMER.md` - Shimmer documentation

**When to Add:**
- New reusable widgets
- Widgets used by multiple features

**How to Add:**
```dart
// widgets/loading_indicator.dart
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;
  
  const LoadingIndicator({
    super.key,
    this.message,
    this.size,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size ?? 40,
          height: size ?? 40,
          child: const CircularProgressIndicator(),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(message!),
        ],
      ],
    );
  }
}

// widgets/widgets_export.dart
export 'loading_indicator.dart';
```

---

## 🚀 How to Add New Components

### Step-by-Step Process:

1. **Identify the Right Folder**
   - Determine which core folder your component belongs to
   - Check if similar components already exist

2. **Create the File**
   - Create new file in appropriate folder
   - Follow naming conventions

3. **Implement the Component**
   - Write the code following existing patterns
   - Add documentation

4. **Export (If Needed)**
   - Add to export file if folder has one
   - Update exports in parent folders

5. **Update Documentation**
   - Update this guide if needed
   - Add inline documentation

6. **Test**
   - Test the component
   - Ensure it works across features

---

## ✅ Best Practices

### 1. **Naming Conventions**

- **Files:** `snake_case.dart` (e.g., `app_config.dart`)
- **Classes:** `PascalCase` (e.g., `AppConfig`)
- **Constants:** `camelCase` for static (e.g., `appName`)
- **Enums:** `PascalCase` (e.g., `AppState`)

### 2. **File Organization**

- One class per file (unless closely related)
- Group related constants together
- Use exports for easy importing

### 3. **Documentation**

- Document all public APIs
- Add examples for complex utilities
- Document when to use each component

### 4. **Dependencies**

- Core should have minimal dependencies
- Avoid feature-specific dependencies
- Use abstract interfaces when possible

### 5. **Testing**

- Test core utilities thoroughly
- Mock dependencies in tests
- Test edge cases

### 6. **Exports**

- Create export files for easy importing
- Group related exports
- Document export files

**Example Export File:**
```dart
// utils/utils_export.dart
/// Core utilities export
/// 
/// Usage:
/// ```dart
/// import 'package:your_app/core/utils/utils_export.dart';
/// ```

// Error handling
export 'error_handler.dart';

// Extensions
export 'extensions_export.dart';

// Validators
export 'validators.dart';

// Helpers
export 'flavor_helper.dart';
```

---

## 📝 Examples

### Example 1: Adding a New Constant

**File:** `constants/app_constants.dart`

```dart
class AppConstants {
  // ... existing constants
  
  // New constants
  static const int maxUploadSize = 10 * 1024 * 1024; // 10MB
  static const Duration sessionTimeout = Duration(hours: 24);
  static const int maxRetryAttempts = 3;
}
```

### Example 2: Adding a New Extension

**File:** `utils/color_extensions.dart`

```dart
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Check if color is dark
  bool get isDark {
    final luminance = computeLuminance();
    return luminance < 0.5;
  }
  
  /// Get contrasting color (black or white)
  Color get contrastingColor {
    return isDark ? Colors.white : Colors.black;
  }
  
  /// Lighten color by percentage
  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  /// Darken color by percentage
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
```

**Then export:**
```dart
// utils/extensions_export.dart
export 'color_extensions.dart';
```

### Example 3: Adding a New Widget

**File:** `widgets/empty_state.dart`

```dart
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**Then export:**
```dart
// widgets/widgets_export.dart
export 'empty_state.dart';
```

### Example 4: Adding a New API Endpoint

**File:** `network/app_urls.dart`

```dart
class AppUrls {
  // ... existing URLs
  
  // New endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String userPosts(String userId) => '/users/$userId/posts';
  static String searchUsers(String query) => '/users/search?q=$query';
}
```

### Example 5: Adding a New Route

**File:** `router/app_routes.dart`

```dart
class AppRoutes {
  // ... existing routes
  
  // New routes
  static const String users = 'users';
  static const String userDetails = 'users/:id';
  static const String userSettings = 'users/:id/settings';
}
```

**File:** `router/app_router.dart`

```dart
GoRoute(
  path: AppRoutes.path(AppRoutes.users),
  name: AppRoutes.users,
  builder: (context, state) => const UsersPage(),
),
GoRoute(
  path: AppRoutes.path(AppRoutes.userDetails),
  name: AppRoutes.userDetails,
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return UserDetailsPage(userId: id);
  },
),
```

---

## 🎓 Summary

### Quick Reference:

| Folder | Purpose | When to Add |
|--------|---------|-------------|
| `app/` | App-level state | Global app state |
| `config/` | Configuration | New configs, flavors |
| `constants/` | Constants | New constants, enums, strings |
| `di/` | Dependency injection | New core services |
| `enums/` | Shared enums | Enums used by multiple features |
| `failure/` | Exceptions | New exception types |
| `functional/` | FP utilities | Either, Failure types |
| `l10n/` | Localization | New translations |
| `localization/` | Localization service | Localization logic |
| `network/` | Network layer | API endpoints, interceptors |
| `router/` | Navigation | Routes, navigation |
| `storage/` | Local storage | Preferences, keys |
| `theme/` | Theming | Colors, theme config |
| `use_case/` | Base use case | Base use case types |
| `utils/` | Utilities | Extensions, validators, helpers |
| `widgets/` | Reusable widgets | Widgets used by multiple features |

---

## 📚 Additional Resources

- See existing core files for examples
- Check `DI_TEMPLATE.md` for dependency injection
- Check `STORAGE.md` for storage patterns
- Check `SHIMMER.md` for widget documentation

---

**Happy Coding! 🚀**
