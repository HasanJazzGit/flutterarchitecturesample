import 'app_config.dart';
import 'app_flavor.dart';

/// Helper class for flavor-related operations
class FlavorHelper {
  /// Get current flavor
  static AppFlavor get currentFlavor => AppConfig.currentFlavor;

  /// Check if current flavor is development
  static bool get isDevelopment => currentFlavor == AppFlavor.development;

  /// Check if current flavor is staging
  static bool get isStaging => currentFlavor == AppFlavor.staging;

  /// Check if current flavor is production
  static bool get isProduction => currentFlavor == AppFlavor.production;

  /// Get flavor display name
  static String get flavorName => currentFlavor.name;

  /// Check if logging is enabled for current flavor
  static bool get shouldLog => AppConfig.enableLogging;

  /// Check if debug features are enabled
  static bool get enableDebugFeatures => AppConfig.enableDebugFeatures;

  /// Log message only if logging is enabled
  static void log(String message) {
    if (shouldLog) {
      // ignore: avoid_print
      print('[${flavorName.toUpperCase()}] $message');
    }
  }

  /// Log error only if logging is enabled
  static void logError(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (shouldLog) {
      // ignore: avoid_print
      print('[${flavorName.toUpperCase()}] ERROR: $message');
      if (error != null) {
        // ignore: avoid_print
        print('Error: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('StackTrace: $stackTrace');
      }
    }
  }
}
