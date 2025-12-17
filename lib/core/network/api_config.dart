import '../config/app_config.dart';

class ApiConfig {
  // Get base URL from AppConfig based on current flavor
  static String getBaseUrl() {
    return AppConfig.getBaseUrl();
  }
  
  // Get current flavor for debugging/logging
  static String get currentFlavor => AppConfig.currentFlavor.name;
}

