import 'app_pref_keys.dart';

/// Abstract interface for App Preferences
///
/// Best Practice: Abstract interface allows:
/// - Easy testing with mock implementations
/// - Swapping implementations if needed
/// - Dependency inversion principle
///
/// Implementations:
/// - AppPrefImpl (concrete implementation using SharedPreferences)
abstract class AppPref {
  // ==================== Authentication ====================

  /// Save authentication token and update login status
  /// Automatically sets login status, last login time, and session start time
  Future<bool> setToken(String token);

  /// Get authentication token
  /// Returns empty string if not found (safe default)
  String getToken();

  /// Check if token exists and is valid
  bool hasToken();

  /// Save refresh token
  Future<bool> setRefreshToken(String refreshToken);

  /// Get refresh token
  /// Returns empty string if not found (safe default)
  String getRefreshToken();

  /// Save user ID
  Future<bool> setUserId(String userId);

  /// Get user ID
  /// Returns empty string if not found (safe default)
  String getUserId();

  /// Set login status
  Future<bool> setLoginStatus(bool isLoggedIn);

  /// Get login status
  /// Returns false by default (safe default)
  bool getLoginStatus();

  /// Set last login time
  Future<bool> setLastLoginTime(DateTime dateTime);

  /// Get last login time
  /// Returns null if not found or invalid (safe default)
  DateTime? getLastLoginTime();

  /// Set session start time
  Future<bool> setSessionStartTime(DateTime dateTime);

  /// Get session start time
  /// Returns null if not found or invalid (safe default)
  DateTime? getSessionStartTime();

  /// Get session duration in seconds
  /// Returns 0 if no active session (safe default)
  int getSessionDuration();

  /// Check if user is authenticated
  /// Safe check: verifies both token and login status
  bool isAuthenticated();

  /// Check if session is valid (not expired)
  /// [timeoutMinutes] - Session timeout in minutes (default: 30 days)
  bool isSessionValid({int timeoutMinutes = 43200});

  /// Clear all authentication data
  Future<void> clearAuth();

  /// Logout user
  /// Clears auth data but keeps userId and lastLoginTime for analytics
  Future<void> logout();

  // ==================== Theme ====================

  /// Save theme mode
  /// Valid values: 'light', 'dark', 'system'
  Future<bool> setThemeMode(String themeMode);

  /// Get theme mode
  /// Returns 'system' by default (safe default)
  String getThemeMode();

  // ==================== Localization ====================

  /// Save locale
  Future<bool> setLocale(String localeCode);

  /// Get locale
  /// Returns 'en' by default (safe default)
  String getLocale();

  // ==================== Onboarding ====================

  /// Set onboarding completion status
  Future<bool> setOnboardingCompleted(bool completed);

  /// Get onboarding completion status
  /// Returns false by default (safe default)
  bool isOnboardingCompleted();

  // ==================== Generic Methods ====================

  /// Save string value
  Future<bool> setString(String key, String value);

  /// Get string value
  /// Returns null if not found
  String? getString(String key);

  /// Get string value with default
  String getStringOrDefault(String key, String defaultValue);

  /// Save int value
  Future<bool> setInt(String key, int value);

  /// Get int value
  /// Returns null if not found
  int? getInt(String key);

  /// Get int value with default
  int getIntOrDefault(String key, int defaultValue);

  /// Save double value
  Future<bool> setDouble(String key, double value);

  /// Get double value
  /// Returns null if not found
  double? getDouble(String key);

  /// Get double value with default
  double getDoubleOrDefault(String key, double defaultValue);

  /// Save bool value
  Future<bool> setBool(String key, bool value);

  /// Get bool value
  /// Returns null if not found
  bool? getBool(String key);

  /// Get bool value with default
  bool getBoolOrDefault(String key, bool defaultValue);

  /// Save string list
  Future<bool> setStringList(String key, List<String> value);

  /// Get string list
  /// Returns null if not found
  List<String>? getStringList(String key);

  /// Get string list with default
  List<String> getStringListOrDefault(String key, List<String> defaultValue);

  // ==================== Utility Methods ====================

  /// Remove a key
  Future<bool> remove(String key);

  /// Clear all preferences
  /// Use with caution - this clears everything!
  Future<bool> clear();

  /// Check if key exists
  bool containsKey(String key);

  /// Get all keys
  Set<String> getKeys();
}
