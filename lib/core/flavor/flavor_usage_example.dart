// Flavor Usage Examples
//
// This file demonstrates how to use the flavor system in your Flutter app.
// DO NOT import this file in production code - it's for reference only.

import 'app_config.dart';
import 'app_flavor.dart';
import 'flavor_helper.dart';

/// Example: How to use flavors in your code
class FlavorUsageExamples {
  // Example 1: Get current flavor
  void example1() {
    final currentFlavor = AppConfig.currentFlavor;
    print('Current flavor: ${currentFlavor.name}');
  }

  // Example 2: Get flavor-specific API URL
  void example2() {
    final apiUrl = AppConfig.getBaseUrl();
    print('API URL: $apiUrl');
  }

  // Example 3: Check if development flavor
  void example3() {
    if (FlavorHelper.isDevelopment) {
      print('Running in development mode');
      // Enable debug features
    }
  }

  // Example 4: Conditional logging
  void example4() {
    FlavorHelper.log('This will only log in dev/staging');
    FlavorHelper.logError('Error occurred', Exception('Test error'));
  }

  // Example 5: Get flavor-specific app name
  void example5() {
    final appName = AppConfig.appName;
    print('App name: $appName');
    // Development: "Flutter Sample (Dev)"
    // Staging: "Flutter Sample (Staging)"
    // Production: "Flutter Sample Architecture"
  }

  // Example 6: Check if debug features should be enabled
  void example6() {
    if (AppConfig.enableDebugFeatures) {
      // Show debug menu, enable developer options, etc.
      print('Debug features enabled');
    }
  }

  // Example 7: Flavor-specific configuration
  void example7() {
    switch (AppConfig.currentFlavor) {
      case AppFlavor.development:
        // Development-specific config
        print('Using development database');
        break;
      case AppFlavor.staging:
        // Staging-specific config
        print('Using staging database');
        break;
      case AppFlavor.production:
        // Production-specific config
        print('Using production database');
        break;
    }
  }

  // Example 8: Conditional feature flags
  void example8() {
    final showBetaFeatures =
        FlavorHelper.isDevelopment || FlavorHelper.isStaging;
    if (showBetaFeatures) {
      // Show beta features
      print('Beta features visible');
    }
  }
}
