import 'package:shared_preferences/shared_preferences.dart';
import 'app_pref.dart';
import 'app_pref_keys.dart';
import '../storage/encryption_service.dart';

/// Encrypted implementation of AppPref
/// Automatically encrypts/decrypts sensitive data based on encryption flag
/// Falls back to regular storage if encryption is disabled
class AppPrefEncryptedImpl implements AppPref {
  final SharedPreferences _prefs;
  late EncryptionService _encryptionService;
  bool? _encryptionEnabledCache;

  AppPrefEncryptedImpl(
    this._prefs, {
    EncryptionService? encryptionService,
    String? encryptionKey,
    String? encryptionIV,
  }) {
    // Load saved key/IV from preferences or use provided/default
    final savedKey = _prefs.getString(AppPrefKeys.encryptionKey);
    final savedIV = _prefs.getString(AppPrefKeys.encryptionIV);

    _encryptionService =
        encryptionService ??
        EncryptionService(
          encryptionKey: savedKey ?? encryptionKey,
          iv: savedIV ?? encryptionIV,
        );
  }

  /// Get shared preferences instance
  SharedPreferences get _instance => _prefs;

  /// Check if encryption is enabled
  /// Caches the result for performance
  bool _isEncryptionEnabled() {
    _encryptionEnabledCache ??=
        _instance.getBool(AppPrefKeys.encryptionEnabled) ?? false;
    return _encryptionEnabledCache!;
  }

  /// Enable or disable encryption
  @override
  Future<bool> setEncryptionEnabled(bool enabled) async {
    try {
      _encryptionEnabledCache = enabled;
      return await _instance.setBool(AppPrefKeys.encryptionEnabled, enabled);
    } catch (e) {
      return false;
    }
  }

  /// Check if encryption is currently enabled
  @override
  bool isEncryptionEnabled() {
    return _isEncryptionEnabled();
  }

  /// Set encryption key (32 characters recommended for AES-256)
  @override
  Future<bool> setEncryptionKey(String key) async {
    try {
      // Normalize key to 32 characters
      final normalizedKey = _normalizeKey(key);
      // Save key to preferences
      final success = await _instance.setString(
        AppPrefKeys.encryptionKey,
        normalizedKey,
      );
      if (success) {
        // Update encryption service with new key
        _encryptionService.updateKeyAndIV(encryptionKey: normalizedKey);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Set encryption IV (16 characters recommended)
  @override
  Future<bool> setEncryptionIV(String iv) async {
    try {
      // Normalize IV to 16 characters
      final normalizedIV = _normalizeIV(iv);
      // Save IV to preferences
      final success = await _instance.setString(
        AppPrefKeys.encryptionIV,
        normalizedIV,
      );
      if (success) {
        // Update encryption service with new IV
        _encryptionService.updateKeyAndIV(iv: normalizedIV);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Initialize encryption with key and IV
  @override
  Future<bool> initializeEncryption({
    required String key,
    required String iv,
    bool enable = true,
  }) async {
    try {
      // Set key and IV
      final keySuccess = await setEncryptionKey(key);
      final ivSuccess = await setEncryptionIV(iv);
      final enableSuccess = await setEncryptionEnabled(enable);

      return keySuccess && ivSuccess && enableSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Normalize key to exactly 32 characters
  String _normalizeKey(String key) {
    if (key.length == 32) return key;
    if (key.length < 32) {
      return key.padRight(32, '0');
    }
    return key.substring(0, 32);
  }

  /// Normalize IV to exactly 16 characters
  String _normalizeIV(String iv) {
    if (iv.length == 16) return iv;
    if (iv.length < 16) {
      return iv.padRight(16, '0');
    }
    return iv.substring(0, 16);
  }

  // ==================== Private Helpers ====================

  /// Safe string getter with default and optional decryption
  String _getStringSafe(String key, String defaultValue) {
    try {
      final value = _instance.getString(key);
      if (value == null) return defaultValue;

      // Decrypt if encryption is enabled
      if (_isEncryptionEnabled()) {
        return _encryptionService.decrypt(value);
      }
      return value;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe bool getter with default (booleans are not encrypted)
  bool _getBoolSafe(String key, bool defaultValue) {
    try {
      return _instance.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe int getter with default (ints are not encrypted)
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

  /// Save string with optional encryption
  Future<bool> _setStringWithEncryption(String key, String value) async {
    try {
      String valueToSave = value;

      // Encrypt if encryption is enabled
      if (_isEncryptionEnabled()) {
        valueToSave = _encryptionService.encrypt(value);
      }

      return await _instance.setString(key, valueToSave);
    } catch (e) {
      return false;
    }
  }

  // ==================== Authentication ====================

  @override
  Future<bool> setToken(String token) async {
    if (token.isEmpty) return false;
    try {
      final success = await _setStringWithEncryption(AppPrefKeys.token, token);
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
      return await _setStringWithEncryption(
        AppPrefKeys.refreshToken,
        refreshToken,
      );
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
      return await _setStringWithEncryption(AppPrefKeys.userId, userId);
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
      return await _setStringWithEncryption(
        AppPrefKeys.lastLoginTime,
        dateTime.toIso8601String(),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  DateTime? getLastLoginTime() {
    final timeString = _getStringSafe(AppPrefKeys.lastLoginTime, '');
    if (timeString.isEmpty) return null;
    return _parseDateTime(timeString);
  }

  @override
  Future<bool> setSessionStartTime(DateTime dateTime) async {
    try {
      return await _setStringWithEncryption(
        AppPrefKeys.sessionStartTime,
        dateTime.toIso8601String(),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  DateTime? getSessionStartTime() {
    final timeString = _getStringSafe(AppPrefKeys.sessionStartTime, '');
    if (timeString.isEmpty) return null;
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
      return await _setStringWithEncryption(AppPrefKeys.themeMode, themeMode);
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
      return await _setStringWithEncryption(AppPrefKeys.locale, localeCode);
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
    return await _setStringWithEncryption(key, value);
  }

  @override
  String? getString(String key) {
    try {
      final value = _instance.getString(key);
      if (value == null) return null;

      // Decrypt if encryption is enabled
      if (_isEncryptionEnabled()) {
        return _encryptionService.decrypt(value);
      }
      return value;
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
      // Encrypt each string in the list if encryption is enabled
      if (_isEncryptionEnabled()) {
        final encryptedList = value
            .map((item) => _encryptionService.encrypt(item))
            .toList();
        return await _instance.setStringList(key, encryptedList);
      }
      return await _instance.setStringList(key, value);
    } catch (e) {
      return false;
    }
  }

  @override
  List<String>? getStringList(String key) {
    try {
      final list = _instance.getStringList(key);
      if (list == null) return null;

      // Decrypt each string in the list if encryption is enabled
      if (_isEncryptionEnabled()) {
        return list.map((item) => _encryptionService.decrypt(item)).toList();
      }
      return list;
    } catch (e) {
      return null;
    }
  }

  @override
  List<String> getStringListOrDefault(String key, List<String> defaultValue) {
    try {
      final list = getStringList(key);
      return list ?? defaultValue;
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
