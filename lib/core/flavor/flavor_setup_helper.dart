import 'flavor_helper.dart';
import 'app_config.dart';
import 'app_flavor.dart';

/// Helper class for flavor setup and initialization
class FlavorSetupHelper {
  /// Initialize flavor-specific configurations
  /// Call this in main() before runApp()
  static void initialize() {
    if (FlavorHelper.shouldLog) {
      FlavorHelper.log(
        'App initialized with flavor: ${FlavorHelper.flavorName}',
      );
      FlavorHelper.log('API Base URL: ${AppConfig.getBaseUrl()}');
      FlavorHelper.log('Debug features: ${AppConfig.enableDebugFeatures}');
    }
  }

  /// Get flavor-specific configuration map
  static Map<String, dynamic> getFlavorConfig() {
    return {
      'flavor': AppConfig.currentFlavor.name,
      'apiBaseUrl': AppConfig.getBaseUrl(),
      'appName': AppConfig.appName,
      'enableLogging': AppConfig.enableLogging,
      'enableDebugFeatures': AppConfig.enableDebugFeatures,
    };
  }

  /// Print flavor configuration (for debugging)
  static void printFlavorConfig() {
    if (FlavorHelper.shouldLog) {
      final config = getFlavorConfig();
      FlavorHelper.log('=== Flavor Configuration ===');
      config.forEach((key, value) {
        FlavorHelper.log('$key: $value');
      });
      FlavorHelper.log('===========================');
    }
  }
  /// Get environment-specific error reporting configuration
  static Map<String, dynamic> getErrorReportingConfig() {
    return {
      'enabled': AppConfig.currentFlavor != AppFlavor.development,
      'environment': AppConfig.currentFlavor.name.toLowerCase(),
      'logLevel': AppConfig.enableLogging ? 'debug' : 'error',
    };
  }

  /// Get analytics configuration based on flavor
  static Map<String, dynamic> getAnalyticsConfig() {
    return {
      'enabled': AppConfig.currentFlavor == AppFlavor.production,
      'environment': AppConfig.currentFlavor.name.toLowerCase(),
      'debugMode': AppConfig.enableDebugFeatures,
    };
  }
}
