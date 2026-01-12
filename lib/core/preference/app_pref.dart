import 'app_pref_keys.dart';

abstract class AppPref {
  // ==================== Authentication ====================

  Future<bool> setToken(String token, {String? defaultValue});
  String getToken();

  Future<bool> setUserId(String userId, {String? defaultValue});
  String getUserId();

  Future<bool> setLoginStatus(bool isLoggedIn, {bool? defaultValue});
  bool getLoginStatus();

  // ==================== Theme ====================

  Future<bool> setThemeMode(String themeMode, {String? defaultValue}); // 'light', 'dark', 'system'
  String getThemeMode(); // Default: 'system'

  // ==================== Localization ====================

  Future<bool> setLocale(String localeCode, {String? defaultValue});
  String getLocale(); // Default: 'en'

  // ==================== Onboarding ====================

  Future<bool> setOnboardingCompleted(bool completed, {bool? defaultValue});
  bool isOnboardingCompleted(); // Default: false

  // ==================== Generic Methods ====================

  Future<bool> setString(String key, String value, {String? defaultValue});
  String? getString(String key);

  Future<bool> setInt(String key, int value, {int? defaultValue});
  int? getInt(String key);

  Future<bool> setDouble(String key, double value, {double? defaultValue});
  double? getDouble(String key);

  Future<bool> setBool(String key, bool value, {bool? defaultValue});
  bool? getBool(String key);

  Future<bool> setStringList(String key, List<String> value, {List<String>? defaultValue});
  List<String>? getStringList(String key);

  // ==================== Encryption ====================





  // ==================== Utility ====================

  Future<bool> remove(String key);
  Future<bool> clear();
}
