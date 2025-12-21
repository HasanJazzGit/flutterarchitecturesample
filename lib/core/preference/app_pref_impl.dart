import 'package:shared_preferences/shared_preferences.dart';
import 'app_pref.dart';
import 'app_pref_keys.dart';

/// Concrete implementation of AppPref
/// Uses SharedPreferences directly for preference operations
class AppPrefImpl implements AppPref {
  final SharedPreferences _prefs;

  AppPrefImpl(this._prefs);

  /// Get shared preferences instance
  SharedPreferences get _instance => _prefs;

  // ==================== Private Helpers ====================

  /// Safe string getter with default
  String _getStringSafe(String key, String defaultValue) {
    try {
      return _instance.getString(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe bool getter with default
  bool _getBoolSafe(String key, bool defaultValue) {
    try {
      return _instance.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe int getter with default
  int _getIntSafe(String key, int defaultValue) {
    try {
      return _instance.getInt(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe DateTime parser
  DateTime? _parseDateTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      return DateTime.tryParse(timeString);
    } catch (e) {
      return null;
    }
  }

  // ==================== Authentication ====================

  @override
  Future<bool> setToken(String token) async {
    if (token.isEmpty) return false;
    try {
      final success = await _instance.setString(AppPrefKeys.token, token);
      if (success) {
        await Future.wait([
          setLoginStatus(true),
          setLastLoginTime(DateTime.now()),
          setSessionStartTime(DateTime.now()),
        ]);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  String getToken() {
    return _getStringSafe(AppPrefKeys.token, '');
  }

  @override
  bool hasToken() {
    return getToken().isNotEmpty;
  }

  @override
  Future<bool> setRefreshToken(String refreshToken) async {
    if (refreshToken.isEmpty) return false;
    try {
      return await _instance.setString(AppPrefKeys.refreshToken, refreshToken);
    } catch (e) {
      return false;
    }
  }

  @override
  String getRefreshToken() {
    return _getStringSafe(AppPrefKeys.refreshToken, '');
  }

  @override
  Future<bool> setUserId(String userId) async {
    if (userId.isEmpty) return false;
    try {
      return await _instance.setString(AppPrefKeys.userId, userId);
    } catch (e) {
      return false;
    }
  }

  @override
  String getUserId() {
    return _getStringSafe(AppPrefKeys.userId, '');
  }

  @override
  Future<bool> setLoginStatus(bool isLoggedIn) async {
    try {
      return await _instance.setBool(AppPrefKeys.loginStatus, isLoggedIn);
    } catch (e) {
      return false;
    }
  }

  @override
  bool getLoginStatus() {
    return _getBoolSafe(AppPrefKeys.loginStatus, false);
  }

  @override
  Future<bool> setLastLoginTime(DateTime dateTime) async {
    try {
      return await _instance.setString(
        AppPrefKeys.lastLoginTime,
        dateTime.toIso8601String(),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  DateTime? getLastLoginTime() {
    final timeString = _instance.getString(AppPrefKeys.lastLoginTime);
    return _parseDateTime(timeString);
  }

  @override
  Future<bool> setSessionStartTime(DateTime dateTime) async {
    try {
      return await _instance.setString(
        AppPrefKeys.sessionStartTime,
        dateTime.toIso8601String(),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  DateTime? getSessionStartTime() {
    final timeString = _instance.getString(AppPrefKeys.sessionStartTime);
    return _parseDateTime(timeString);
  }

  @override
  int getSessionDuration() {
    final sessionStart = getSessionStartTime();
    if (sessionStart == null) return 0;
    try {
      return DateTime.now().difference(sessionStart).inSeconds;
    } catch (e) {
      return 0;
    }
  }

  @override
  bool isAuthenticated() {
    return hasToken() && getLoginStatus();
  }

  @override
  bool isSessionValid({int timeoutMinutes = 43200}) {
    if (!isAuthenticated()) return false;
    final sessionStart = getSessionStartTime();
    if (sessionStart == null) return false;
    try {
      final duration = DateTime.now().difference(sessionStart);
      return duration.inMinutes < timeoutMinutes;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      await Future.wait([
        _instance.remove(AppPrefKeys.token),
        _instance.remove(AppPrefKeys.refreshToken),
        _instance.remove(AppPrefKeys.userId),
        _instance.remove(AppPrefKeys.loginStatus),
        _instance.remove(AppPrefKeys.lastLoginTime),
        _instance.remove(AppPrefKeys.sessionStartTime),
      ]);
    } catch (e) {
      // Silently fail - already cleared or error occurred
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        setLoginStatus(false),
        _instance.remove(AppPrefKeys.token),
        _instance.remove(AppPrefKeys.refreshToken),
        _instance.remove(AppPrefKeys.sessionStartTime),
      ]);
    } catch (e) {
      // Silently fail - attempt to clear what we can
      await setLoginStatus(false);
    }
  }

  // ==================== Theme ====================

  @override
  Future<bool> setThemeMode(String themeMode) async {
    if (!['light', 'dark', 'system'].contains(themeMode)) {
      return false;
    }
    try {
      return await _instance.setString(AppPrefKeys.themeMode, themeMode);
    } catch (e) {
      return false;
    }
  }

  @override
  String getThemeMode() {
    return _getStringSafe(AppPrefKeys.themeMode, 'system');
  }

  // ==================== Localization ====================

  @override
  Future<bool> setLocale(String localeCode) async {
    if (localeCode.isEmpty) return false;
    try {
      return await _instance.setString(AppPrefKeys.locale, localeCode);
    } catch (e) {
      return false;
    }
  }

  @override
  String getLocale() {
    return _getStringSafe(AppPrefKeys.locale, 'en');
  }

  // ==================== Onboarding ====================

  @override
  Future<bool> setOnboardingCompleted(bool completed) async {
    try {
      return await _instance.setBool(
        AppPrefKeys.onboardingCompleted,
        completed,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  bool isOnboardingCompleted() {
    return _getBoolSafe(AppPrefKeys.onboardingCompleted, false);
  }

  // ==================== Generic Methods ====================

  @override
  Future<bool> setString(String key, String value) async {
    try {
      return await _instance.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  String? getString(String key) {
    try {
      return _instance.getString(key);
    } catch (e) {
      return null;
    }
  }

  @override
  String getStringOrDefault(String key, String defaultValue) {
    return _getStringSafe(key, defaultValue);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    try {
      return await _instance.setInt(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  int? getInt(String key) {
    try {
      return _instance.getInt(key);
    } catch (e) {
      return null;
    }
  }

  @override
  int getIntOrDefault(String key, int defaultValue) {
    return _getIntSafe(key, defaultValue);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _instance.setDouble(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  double? getDouble(String key) {
    try {
      return _instance.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  @override
  double getDoubleOrDefault(String key, double defaultValue) {
    try {
      return _instance.getDouble(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _instance.setBool(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  bool? getBool(String key) {
    try {
      return _instance.getBool(key);
    } catch (e) {
      return null;
    }
  }

  @override
  bool getBoolOrDefault(String key, bool defaultValue) {
    return _getBoolSafe(key, defaultValue);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _instance.setStringList(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  List<String>? getStringList(String key) {
    try {
      return _instance.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  @override
  List<String> getStringListOrDefault(String key, List<String> defaultValue) {
    try {
      return _instance.getStringList(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // ==================== Utility Methods ====================

  @override
  Future<bool> remove(String key) async {
    try {
      return await _instance.remove(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clear() async {
    try {
      return await _instance.clear();
    } catch (e) {
      return false;
    }
  }

  @override
  bool containsKey(String key) {
    try {
      return _instance.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Set<String> getKeys() {
    try {
      return _instance.getKeys();
    } catch (e) {
      return <String>{};
    }
  }
}
