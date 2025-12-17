import '../config/app_config.dart';

class AppConstants {
  // App Info - Get from AppConfig based on flavor
  static String get appName => AppConfig.appName;
  static const String appVersion = '1.0.0';

  // API Constants (in seconds for Dio)
  static const int connectionTimeout = 30; // 30 seconds
  static const int receiveTimeout = 30; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minEmailLength = 5;
  static const int maxEmailLength = 255;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce
  static const Duration debounceDelay = Duration(milliseconds: 500);
}

