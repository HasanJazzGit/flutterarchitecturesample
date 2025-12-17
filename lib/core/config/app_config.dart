import '../constants/app_flavor.dart';

/// App configuration based on current flavor
///
/// Usage:
/// - Set flavor via environment variable: --dart-define=APP_FLAVOR=production
/// - Set API URL via environment variable: --dart-define=API_BASE_URL=https://api.example.com
///
/// Examples:
///   flutter run --dart-define=APP_FLAVOR=development
///   flutter run --dart-define=APP_FLAVOR=staging
///   flutter run --dart-define=APP_FLAVOR=production
///   flutter build apk --dart-define=APP_FLAVOR=production
class AppConfig {
  /// Get current flavor from environment variable
  /// Defaults to 'development' if not specified
  static AppFlavor get currentFlavor {
    const flavorString = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'development',
    );

    switch (flavorString.toLowerCase()) {
      case 'production':
        return AppFlavor.production;
      case 'staging':
        return AppFlavor.staging;
      case 'development':
      default:
        return AppFlavor.development;
    }
  }

  // App configuration getters
  static String get appName => currentFlavor.appName;
  static String get apiBaseUrl => currentFlavor.apiBaseUrl;
  static bool get enableLogging => currentFlavor.enableLogging;
  static bool get enableDebugFeatures => currentFlavor.enableDebugFeatures;

  // Override with environment variable if provided
  static String getBaseUrl() {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');

    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    return currentFlavor.apiBaseUrl;
  }
}
