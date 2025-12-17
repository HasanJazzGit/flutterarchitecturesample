import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing shared preferences
/// Provides a clean interface for storing and retrieving data
class SharedPreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize shared preferences
  /// Should be called before using the service
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get shared preferences instance
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferencesService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Check if preferences is initialized
  static bool get isInitialized => _prefs != null;

  // String operations
  static Future<bool> setString(String key, String value) async {
    return await instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  static String getStringOrDefault(String key, String defaultValue) {
    return instance.getString(key) ?? defaultValue;
  }

  // Int operations
  static Future<bool> setInt(String key, int value) async {
    return await instance.setInt(key, value);
  }

  static int? getInt(String key) {
    return instance.getInt(key);
  }

  static int getIntOrDefault(String key, int defaultValue) {
    return instance.getInt(key) ?? defaultValue;
  }

  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    return await instance.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return instance.getDouble(key);
  }

  static double getDoubleOrDefault(String key, double defaultValue) {
    return instance.getDouble(key) ?? defaultValue;
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    return await instance.setBool(key, value);
  }

  static bool? getBool(String key) {
    return instance.getBool(key);
  }

  static bool getBoolOrDefault(String key, bool defaultValue) {
    return instance.getBool(key) ?? defaultValue;
  }

  // String list operations
  static Future<bool> setStringList(String key, List<String> value) async {
    return await instance.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return instance.getStringList(key);
  }

  static List<String> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) {
    return instance.getStringList(key) ?? defaultValue;
  }

  // Remove operations
  static Future<bool> remove(String key) async {
    return await instance.remove(key);
  }

  static Future<bool> clear() async {
    return await instance.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  // Get all keys
  static Set<String> getKeys() {
    return instance.getKeys();
  }
}
