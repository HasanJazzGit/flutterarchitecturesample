# Flavor Usage Guide

## Running with Different Flavors

### Development (Default)
```bash
# Run in development mode (default)
flutter run

# Or explicitly
flutter run --dart-define=APP_FLAVOR=development
```

### Staging
```bash
# Run in staging mode
flutter run --dart-define=APP_FLAVOR=staging

# With custom API URL
flutter run --dart-define=APP_FLAVOR=staging --dart-define=API_BASE_URL=https://staging-api.example.com
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

## Override API URL

You can override the API URL for any flavor:

```bash
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom-api.com
```

## Using Flavors in Code

### Get Current Flavor
```dart
import 'package:your_app/core/flavor/app_config.dart';

final flavor = AppConfig.currentFlavor;
print(flavor.name); // "Development", "Staging", or "Production"
```

### Get API URL
```dart
final apiUrl = AppConfig.getBaseUrl();
```

### Check Flavor
```dart
import 'package:your_app/core/flavor/flavor_helper.dart';

if (FlavorHelper.isDevelopment) {
  // Development-only code
}

if (FlavorHelper.isProduction) {
  // Production-only code
}
```

### Conditional Logging
```dart
FlavorHelper.log('Debug message'); // Only logs in dev/staging
FlavorHelper.logError('Error', exception);
```

### Get App Name
```dart
final appName = AppConfig.appName;
// Development: "Flutter Sample (Dev)"
// Staging: "Flutter Sample (Staging)"
// Production: "Flutter Sample Architecture"
```

## Flavor Configuration

Edit `lib/core/flavor/app_flavor.dart` to customize:

- API URLs for each flavor
- App names for each flavor
- Enable/disable logging
- Enable/disable debug features

## VS Code Launch Configuration

Add to `.vscode/launch.json`:

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
    }
  ]
}
```

## Android Studio Run Configuration

1. Go to Run → Edit Configurations
2. Add new Flutter configuration
3. In "Additional run args", add: `--dart-define=APP_FLAVOR=staging`
4. Save and use the configuration

