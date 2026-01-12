import 'package:shared_preferences/shared_preferences.dart';
import '../storage/encryption_service.dart';
import 'app_pref.dart';
import 'app_pref_keys.dart';

/// A secure App Preferences implementation using AES EncryptionService.
/// Automatically encrypts/decrypts values before saving to SharedPreferences.
class AppPrefImpl implements AppPref {
  final SharedPreferences _prefs;
  final EncryptionService _encryptionService;

  AppPrefImpl(
      this._prefs, {
        EncryptionService? encryptionService,
      }) : _encryptionService = encryptionService ?? EncryptionService();



  SharedPreferences get _instance => _prefs;

  // ==================== Core Encryption Helpers ====================

  Future<bool> _setEncrypted(String key, String value) async {
    try {
      final encryptedValue = _encryptionService.encrypt(value);
      return await _instance.setString(key, encryptedValue);
    } catch (_) {
      return false;
    }
  }

  String _getDecrypted(String key, [String defaultValue = '']) {
    try {
      final value = _instance.getString(key);
      if (value == null || value.isEmpty) return defaultValue;
      return _encryptionService.decrypt(value);
    } catch (_) {
      return defaultValue;
    }
  }

  // ==================== Authentication ====================

  @override
  Future<bool> setToken(String token, {String? defaultValue}) async {
    final val = token.isNotEmpty ? token : (defaultValue ?? '');
    return _setEncrypted(AppPrefKeys.token, val);
  }

  @override
  String getToken() => _getDecrypted(AppPrefKeys.token, '');

  @override
  Future<bool> setUserId(String userId, {String? defaultValue}) async {
    final val = userId.isNotEmpty ? userId : (defaultValue ?? '');
    return _setEncrypted(AppPrefKeys.userId, val);
  }

  @override
  String getUserId() => _getDecrypted(AppPrefKeys.userId, '');

  @override
  Future<bool> setLoginStatus(bool isLoggedIn, {bool? defaultValue}) async {
    return _instance.setBool(AppPrefKeys.loginStatus, isLoggedIn);
  }

  @override
  bool getLoginStatus() => _instance.getBool(AppPrefKeys.loginStatus) ?? false;

  // ==================== Theme ====================

  @override
  Future<bool> setThemeMode(String themeMode, {String? defaultValue}) async {
    final val = themeMode.isNotEmpty ? themeMode : (defaultValue ?? 'dark');
    return _setEncrypted(AppPrefKeys.themeMode, val);
  }

  @override
  String getThemeMode() => _getDecrypted(AppPrefKeys.themeMode, 'dark');

  // ==================== Localization ====================

  @override
  Future<bool> setLocale(String localeCode, {String? defaultValue}) async {
    final val = localeCode.isNotEmpty ? localeCode : (defaultValue ?? 'en');
    return _setEncrypted(AppPrefKeys.locale, val);
  }

  @override
  String getLocale() => _getDecrypted(AppPrefKeys.locale, 'en');

  // ==================== Onboarding ====================

  @override
  Future<bool> setOnboardingCompleted(bool completed, {bool? defaultValue}) async {
    return _instance.setBool(AppPrefKeys.onboardingCompleted, completed);
  }

  @override
  bool isOnboardingCompleted() =>
      _instance.getBool(AppPrefKeys.onboardingCompleted) ?? false;

  // ==================== Generic ====================

  @override
  Future<bool> setString(String key, String value, {String? defaultValue}) async {
    final val = value.isNotEmpty ? value : (defaultValue ?? '');
    return _setEncrypted(key, val);
  }

  @override
  String? getString(String key) {
    final value = _instance.getString(key);
    if (value == null) return null;
    return _encryptionService.decrypt(value);
  }

  @override
  Future<bool> setInt(String key, int value, {int? defaultValue}) async {
    return _instance.setInt(key, value);
  }

  @override
  int? getInt(String key) => _instance.getInt(key);

  @override
  Future<bool> setDouble(String key, double value, {double? defaultValue}) async {
    return _instance.setDouble(key, value);
  }

  @override
  double? getDouble(String key) => _instance.getDouble(key);

  @override
  Future<bool> setBool(String key, bool value, {bool? defaultValue}) async {
    return _instance.setBool(key, value);
  }

  @override
  bool? getBool(String key) => _instance.getBool(key);

  @override
  Future<bool> setStringList(String key, List<String> value,
      {List<String>? defaultValue}) async {
    try {
      final list = value.isNotEmpty ? value : (defaultValue ?? []);
      final encryptedList = list.map((e) => _encryptionService.encrypt(e)).toList();
      return await _instance.setStringList(key, encryptedList);
    } catch (_) {
      return false;
    }
  }

  @override
  List<String>? getStringList(String key) {
    final list = _instance.getStringList(key);
    if (list == null) return null;
    return list.map((e) => _encryptionService.decrypt(e)).toList();
  }

  // ==================== Utility ====================

  @override
  Future<bool> remove(String key) async => _instance.remove(key);

  @override
  Future<bool> clear() async => _instance.clear();

}
