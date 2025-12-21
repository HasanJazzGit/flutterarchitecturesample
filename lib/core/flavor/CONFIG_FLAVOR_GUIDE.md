# ⚙️ Configuration & Flavors Guide

Complete guide for managing app configurations and flavors (development, staging, production) in this Flutter project.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What are Flavors?](#what-are-flavors)
3. [Available Flavors](#available-flavors)
4. [File Structure](#file-structure)
5. [Running with Flavors](#running-with-flavors)
6. [Using Flavors in Code](#using-flavors-in-code)
7. [Configuration Classes](#configuration-classes)
8. [Customizing Flavors](#customizing-flavors)
9. [IDE Setup](#ide-setup)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

---

## 📖 Overview

**Flavors** allow you to build different versions of your app with different configurations (API URLs, app names, debug features, etc.) without changing code.

### Benefits
- ✅ Different API endpoints per environment
- ✅ Different app names/branding
- ✅ Enable/disable debug features
- ✅ Control logging per environment
- ✅ Feature flags per environment

---

## 🎯 What are Flavors?

Flavors are **build variants** of your app. Think of them as different "modes" your app can run in:

- **Development** - For local development and testing
- **Staging** - For testing before production
- **Production** - For end users

Each flavor can have:
- Different API base URLs
- Different app names
- Different feature flags
- Different logging levels

---

## 🏷️ Available Flavors

### 1. Development (Default)
- **App Name**: `Flutter Sample (Dev)`
- **API URL**: `https://dev-api.example.com/api`
- **Logging**: ✅ Enabled
- **Debug Features**: ✅ Enabled
- **Use Case**: Local development, debugging

### 2. Staging
- **App Name**: `Flutter Sample (Staging)`
- **API URL**: `https://staging-api.example.com/api`
- **Logging**: ✅ Enabled
- **Debug Features**: ✅ Enabled
- **Use Case**: Testing before production release

### 3. Production
- **App Name**: `Flutter Sample Architecture`
- **API URL**: `https://api.example.com/api`
- **Logging**: ❌ Disabled
- **Debug Features**: ❌ Disabled
- **Use Case**: Production release for end users

---

## 📁 File Structure

```
lib/core/
├── config/
│   ├── app_config.dart              # Main configuration class
│   ├── app_flavor.dart              # Flavor enum definition
│   ├── flavor_setup_helper.dart     # Flavor initialization helper
│   ├── flavor_usage_example.dart    # Usage examples
│   └── flavor_commands.md           # Quick command reference
│
└── utils/
    └── flavor_helper.dart            # Flavor utility helpers
```

### Key Files

| File | Purpose |
|------|---------|
| `app_config.dart` | Main config class - get current flavor, API URL, etc. |
| `app_flavor.dart` | Flavor enum with configuration for each flavor |
| `flavor_setup_helper.dart` | Helper for initializing and managing flavors |
| `flavor_helper.dart` | Utility methods for checking flavors, logging |

---

## 🚀 Running with Flavors

### Development (Default)

```bash
# Run without specifying (defaults to development)
flutter run

# Or explicitly
flutter run --dart-define=APP_FLAVOR=development
```

### Staging

```bash
# Run in staging mode
flutter run --dart-define=APP_FLAVOR=staging

# With custom API URL override
flutter run --dart-define=APP_FLAVOR=staging --dart-define=API_BASE_URL=https://custom-staging-api.com
```

### Production

```bash
# Run in production mode
flutter run --dart-define=APP_FLAVOR=production

# Build APK for production
flutter build apk --dart-define=APP_FLAVOR=production

# Build iOS for production
flutter build ios --dart-define=APP_FLAVOR=production

# Build App Bundle for production
flutter build appbundle --dart-define=APP_FLAVOR=production
```

### Override API URL

You can override the API URL for any flavor:

```bash
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom-api.com
```

---

## 💻 Using Flavors in Code

### Get Current Flavor

```dart
import 'package:fluttersampleachitecture/core/flavor/app_config.dart';

final flavor = AppConfig.currentFlavor;
print(flavor.name); // "Development", "Staging", or "Production"
```

### Get API URL

```dart
import 'package:fluttersampleachitecture/core/flavor/app_config.dart';

final apiUrl = AppConfig.getBaseUrl();
// Returns flavor-specific URL or overridden URL from environment
```

### Get App Name

```dart
final appName = AppConfig.appName;
// Development: "Flutter Sample (Dev)"
// Staging: "Flutter Sample (Staging)"
// Production: "Flutter Sample Architecture"
```

### Check Flavor Type

```dart
import 'package:fluttersampleachitecture/core/flavor/flavor_helper.dart';

if (FlavorHelper.isDevelopment) {
  // Development-only code
  print('Running in development mode');
}

if (FlavorHelper.isStaging) {
  // Staging-only code
}

if (FlavorHelper.isProduction) {
  // Production-only code
}
```

### Conditional Logging

```dart
import 'package:fluttersampleachitecture/core/flavor/flavor_helper.dart';

// Only logs if logging is enabled for current flavor
FlavorHelper.log('Debug message');
FlavorHelper.logError('Error occurred', exception, stackTrace);
```

### Check Debug Features

```dart
if (AppConfig.enableDebugFeatures) {
  // Show debug menu, enable developer options, etc.
  showDebugMenu();
}
```

### Flavor-Specific Configuration

```dart
import 'package:fluttersampleachitecture/core/flavor/app_config.dart';
import 'package:fluttersampleachitecture/core/flavor/app_flavor.dart';

switch (AppConfig.currentFlavor) {
  case AppFlavor.development:
    // Development-specific config
    databaseUrl = 'dev-database-url';
    break;
  case AppFlavor.staging:
    // Staging-specific config
    databaseUrl = 'staging-database-url';
    break;
  case AppFlavor.production:
    // Production-specific config
    databaseUrl = 'production-database-url';
    break;
}
```

### Conditional Feature Flags

```dart
import 'package:fluttersampleachitecture/core/flavor/flavor_helper.dart';

// Show beta features only in dev/staging
final showBetaFeatures = FlavorHelper.isDevelopment || FlavorHelper.isStaging;

if (showBetaFeatures) {
  // Show beta features
}
```

---

## 🏗️ Configuration Classes

### AppConfig

Main configuration class that provides access to flavor-specific settings.

```dart
class AppConfig {
  // Get current flavor
  static AppFlavor get currentFlavor;
  
  // Get flavor-specific app name
  static String get appName;
  
  // Get flavor-specific API base URL
  static String get apiBaseUrl;
  
  // Get base URL (with environment override support)
  static String getBaseUrl();
  
  // Check if logging is enabled
  static bool get enableLogging;
  
  // Check if debug features are enabled
  static bool get enableDebugFeatures;
}
```

### FlavorHelper

Utility class for flavor-related operations.

```dart
class FlavorHelper {
  // Get current flavor
  static AppFlavor get currentFlavor;
  
  // Check flavor type
  static bool get isDevelopment;
  static bool get isStaging;
  static bool get isProduction;
  
  // Get flavor name
  static String get flavorName;
  
  // Check if logging enabled
  static bool get shouldLog;
  
  // Logging methods
  static void log(String message);
  static void logError(String message, [Object? error, StackTrace? stackTrace]);
}
```

### FlavorSetupHelper

Helper for initializing and managing flavors.

```dart
class FlavorSetupHelper {
  // Initialize flavor (call in main())
  static void initialize();
  
  // Get flavor configuration map
  static Map<String, dynamic> getFlavorConfig();
  
  // Print flavor config (for debugging)
  static void printFlavorConfig();
  
  // Check if feature should be enabled
  static bool shouldEnableFeature(String featureName);
  
  // Get error reporting config
  static Map<String, dynamic> getErrorReportingConfig();
  
  // Get analytics config
  static Map<String, dynamic> getAnalyticsConfig();
}
```

---

## 🎨 Customizing Flavors

### Step 1: Edit Flavor Enum

Edit `lib/core/flavor/app_flavor.dart`:

```dart
enum AppFlavor {
  development(
    appName: 'Flutter Sample (Dev)',
    apiBaseUrl: 'https://dev-api.example.com/api',
    enableLogging: true,
    enableDebugFeatures: true,
  ),
  staging(
    appName: 'Flutter Sample (Staging)',
    apiBaseUrl: 'https://staging-api.example.com/api',
    enableLogging: true,
    enableDebugFeatures: true,
  ),
  production(
    appName: 'Flutter Sample Architecture',
    apiBaseUrl: 'https://api.example.com/api',
    enableLogging: false,
    enableDebugFeatures: false,
  );

  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableDebugFeatures;

  const AppFlavor({
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableDebugFeatures,
  });
}
```

### Step 2: Add New Flavor (Optional)

If you need a new flavor (e.g., `qa`):

1. Add to enum in `app_flavor.dart`
2. Update switch statement in `app_config.dart`
3. Update `FlavorHelper` if needed

---

## 🛠️ IDE Setup

### VS Code Launch Configuration

Create or edit `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=development"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=staging"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=production"]
    },
    {
      "name": "Development (Custom API)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=APP_FLAVOR=development",
        "--dart-define=API_BASE_URL=https://custom-api.com"
      ]
    }
  ]
}
```

### Android Studio Run Configuration

1. Go to **Run → Edit Configurations**
2. Click **+** → **Flutter**
3. Set **Name**: `Development`, `Staging`, or `Production`
4. In **Additional run args**, add:
   - `--dart-define=APP_FLAVOR=development`
   - `--dart-define=APP_FLAVOR=staging`
   - `--dart-define=APP_FLAVOR=production`
5. Save and use from the run configuration dropdown

---

## ✅ Best Practices

### 1. **Always Use Flavor Helpers**
```dart
// ✅ Good
if (FlavorHelper.isDevelopment) {
  // dev code
}

// ❌ Bad
if (AppConfig.currentFlavor == AppFlavor.development) {
  // dev code
}
```

### 2. **Use Conditional Logging**
```dart
// ✅ Good - Only logs if enabled
FlavorHelper.log('Debug message');

// ❌ Bad - Always logs
print('Debug message');
```

### 3. **Never Hardcode URLs**
```dart
// ✅ Good
final url = AppConfig.getBaseUrl();

// ❌ Bad
final url = 'https://api.example.com';
```

### 4. **Initialize in main()**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize flavor first
  FlavorSetupHelper.initialize();
  FlavorSetupHelper.printFlavorConfig();
  
  // Then initialize other things
  await initDependencyInjection();
  
  runApp(const FlutterSampleApp());
}
```

### 5. **Use Feature Flags**
```dart
// ✅ Good - Feature flags based on flavor
if (FlavorSetupHelper.shouldEnableFeature('experimental')) {
  // Show experimental feature
}
```

### 6. **Test All Flavors**
Always test your app in all flavors before releasing:
- ✅ Development
- ✅ Staging
- ✅ Production

---

## 🔧 Troubleshooting

### Problem: Flavor Not Changing

**Solution:**
1. Check command syntax: `--dart-define=APP_FLAVOR=development`
2. Restart the app completely (hot restart may not pick up flavor changes)
3. Clean build: `flutter clean && flutter pub get`

### Problem: Wrong API URL

**Solution:**
1. Check `app_flavor.dart` for correct URLs
2. Check if `API_BASE_URL` environment variable is overriding
3. Use `AppConfig.getBaseUrl()` to see what URL is being used

### Problem: Logging Not Working

**Solution:**
1. Check `enableLogging` in `app_flavor.dart`
2. Ensure using `FlavorHelper.log()` not `print()`
3. Check flavor is set correctly

### Problem: Debug Features Not Showing

**Solution:**
1. Check `enableDebugFeatures` in `app_flavor.dart`
2. Verify flavor is set to development/staging
3. Check `AppConfig.enableDebugFeatures` in code

### Problem: App Name Not Changing

**Solution:**
1. Check `appName` in `app_flavor.dart`
2. Restart app (not hot reload)
3. Check if app name is hardcoded somewhere

---

## 📝 Quick Reference

### Commands

```bash
# Development
flutter run --dart-define=APP_FLAVOR=development

# Staging
flutter run --dart-define=APP_FLAVOR=staging

# Production
flutter run --dart-define=APP_FLAVOR=production
flutter build apk --dart-define=APP_FLAVOR=production

# With custom API URL
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom.com
```

### Code Snippets

```dart
// Get current flavor
final flavor = AppConfig.currentFlavor;

// Get API URL
final url = AppConfig.getBaseUrl();

// Check flavor
if (FlavorHelper.isDevelopment) { }

// Logging
FlavorHelper.log('Message');
FlavorHelper.logError('Error', exception);

// Feature flags
if (AppConfig.enableDebugFeatures) { }
```

### File Locations

- **Config**: `lib/core/flavor/app_config.dart`
- **Flavor Enum**: `lib/core/flavor/app_flavor.dart`
- **Helper**: `lib/core/flavor/flavor_helper.dart`
- **Setup**: `lib/core/flavor/flavor_setup_helper.dart`

---

## 🎯 Summary

1. ✅ Flavors allow different app configurations per environment
2. ✅ Use `--dart-define=APP_FLAVOR=development` to set flavor
3. ✅ Use `AppConfig` and `FlavorHelper` to access flavor settings
4. ✅ Always use conditional logging with `FlavorHelper.log()`
5. ✅ Test all flavors before releasing

---

**Need Help?** Check the [Flutter Documentation on Build Modes](https://docs.flutter.dev/deployment/flavors)
