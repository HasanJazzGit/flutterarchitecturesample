import 'shared_preferences_service.dart';

/// Storage keys for AppPref
/// All preference keys should be defined here
class AppPrefKeys {
  AppPrefKeys._(); // Private constructor

  // Authentication keys
  static const String token = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';

  // Theme keys
  static const String themeMode = 'theme_mode';

  // Add more keys as needed
  // Example:
  // static const String language = 'app_language';
  // static const String onboardingCompleted = 'onboarding_completed';
}

/// App preferences manager
/// Provides convenient methods for storing and retrieving app-specific data
class AppPref {
  // Private constructor to prevent instantiation
  AppPref._();

  /// Initialize app preferences
  /// Must be called before using AppPref
  static Future<void> init() async {
    await SharedPreferencesService.init();
  }

  // ==================== Authentication ====================

  /// Save authentication token
  static Future<bool> setToken(String token) async {
    return await SharedPreferencesService.setString(AppPrefKeys.token, token);
  }

  /// Get authentication token
  static String? getToken() {
    return SharedPreferencesService.getString(AppPrefKeys.token);
  }

  /// Check if user is authenticated (has token)
  static bool isAuthenticated() {
    return getToken() != null && getToken()!.isNotEmpty;
  }

  /// Save refresh token
  static Future<bool> setRefreshToken(String refreshToken) async {
    return await SharedPreferencesService.setString(
      AppPrefKeys.refreshToken,
      refreshToken,
    );
  }

  /// Get refresh token
  static String? getRefreshToken() {
    return SharedPreferencesService.getString(AppPrefKeys.refreshToken);
  }

  /// Save user ID
  static Future<bool> setUserId(String userId) async {
    return await SharedPreferencesService.setString(AppPrefKeys.userId, userId);
  }

  /// Get user ID
  static String? getUserId() {
    return SharedPreferencesService.getString(AppPrefKeys.userId);
  }

  /// Clear authentication data (token, refresh token, user ID)
  static Future<void> clearAuth() async {
    await SharedPreferencesService.remove(AppPrefKeys.token);
    await SharedPreferencesService.remove(AppPrefKeys.refreshToken);
    await SharedPreferencesService.remove(AppPrefKeys.userId);
  }

  // ==================== Theme ====================

  /// Save theme mode
  /// themeMode should be 'light', 'dark', or 'system'
  static Future<bool> setThemeMode(String themeMode) async {
    return await SharedPreferencesService.setString(
      AppPrefKeys.themeMode,
      themeMode,
    );
  }

  /// Get theme mode
  /// Returns 'light', 'dark', or 'system', defaults to 'system'
  static String getThemeMode() {
    return SharedPreferencesService.getStringOrDefault(
      AppPrefKeys.themeMode,
      'system',
    );
  }

  // ==================== Generic Methods ====================

  /// Save string value
  static Future<bool> setString(String key, String value) async {
    return await SharedPreferencesService.setString(key, value);
  }

  /// Get string value
  static String? getString(String key) {
    return SharedPreferencesService.getString(key);
  }

  /// Get string value with default
  static String getStringOrDefault(String key, String defaultValue) {
    return SharedPreferencesService.getStringOrDefault(key, defaultValue);
  }

  /// Save int value
  static Future<bool> setInt(String key, int value) async {
    return await SharedPreferencesService.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key) {
    return SharedPreferencesService.getInt(key);
  }

  /// Get int value with default
  static int getIntOrDefault(String key, int defaultValue) {
    return SharedPreferencesService.getIntOrDefault(key, defaultValue);
  }

  /// Save double value
  static Future<bool> setDouble(String key, double value) async {
    return await SharedPreferencesService.setDouble(key, value);
  }

  /// Get double value
  static double? getDouble(String key) {
    return SharedPreferencesService.getDouble(key);
  }

  /// Get double value with default
  static double getDoubleOrDefault(String key, double defaultValue) {
    return SharedPreferencesService.getDoubleOrDefault(key, defaultValue);
  }

  /// Save bool value
  static Future<bool> setBool(String key, bool value) async {
    return await SharedPreferencesService.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key) {
    return SharedPreferencesService.getBool(key);
  }

  /// Get bool value with default
  static bool getBoolOrDefault(String key, bool defaultValue) {
    return SharedPreferencesService.getBoolOrDefault(key, defaultValue);
  }

  /// Save string list
  static Future<bool> setStringList(String key, List<String> value) async {
    return await SharedPreferencesService.setStringList(key, value);
  }

  /// Get string list
  static List<String>? getStringList(String key) {
    return SharedPreferencesService.getStringList(key);
  }

  /// Get string list with default
  static List<String> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) {
    return SharedPreferencesService.getStringListOrDefault(key, defaultValue);
  }

  // ==================== Utility Methods ====================

  /// Remove a key
  static Future<bool> remove(String key) async {
    return await SharedPreferencesService.remove(key);
  }

  /// Clear all preferences
  static Future<bool> clear() async {
    return await SharedPreferencesService.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return SharedPreferencesService.containsKey(key);
  }

  /// Get all keys
  static Set<String> getKeys() {
    return SharedPreferencesService.getKeys();
  }
}
