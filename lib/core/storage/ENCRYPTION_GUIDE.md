# 🔐 Encryption & Secure Preferences Setup Guide

## 📄 Overview

This guide explains how to use `EncryptionService` and `AppPrefEncryptedImpl` for securely storing data in Flutter apps.  
It uses **AES-256 encryption** with:
- A secure **native key** (from Android/iOS via method channel)
- A **random secret key** stored in `FlutterSecureStorage`

Together, these generate a robust encryption key used across your app.

---

## ⚙️ 1. EncryptionService

### Purpose

`EncryptionService` manages encryption and decryption using AES-256.  
It securely initializes keys, then provides `encrypt()` and `decrypt()` methods.

---

### 🔧 Setup

#### Step 1 — Add Dependencies

```yaml
dependencies:
  encrypt: ^5.0.1
  flutter_secure_storage: ^9.0.0
```

---

#### Step 2 — Native Integration

##### Android (Kotlin)
Create or update your `MainActivity.kt`:

```kotlin
class MainActivity : FlutterActivity() {
    private val CHANNEL = "encryption_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getEncryptionKey") {
                    // 🔑 Provide your secure key here (fetch from keystore or static for testing)
                    result.success("MySuperSecureNativeKey123!")
                } else {
                    result.notImplemented()
                }
            }
    }
}
´

##### iOS (Swift)
In `AppDelegate.swift`:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channel = "encryption_channel"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { call, result in
      if call.method == "getEncryptionKey" {
        // 🔑 Provide secure key
        result("MySuperSecureNativeKey123!")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

#### Step 3 — Flutter Code

`lib/storage/encryption_service.dart`

```dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  static const String _secretKeyName = 'app_random_secret_key';
  static const MethodChannel _methodChannel = MethodChannel('encryption_channel');

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late String _nativeKey;
  late String _randomSecret;
  late encrypt.Encrypter _encrypter;
  late encrypt.IV _iv;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _nativeKey = await _getNativeKey();

    String? storedSecret = await _secureStorage.read(key: _secretKeyName);
    if (storedSecret == null) {
      storedSecret = _generateRandomSecret();
      await _secureStorage.write(key: _secretKeyName, value: storedSecret);
    }
    _randomSecret = storedSecret;

    final combinedKey = _combineKeys(_nativeKey, _randomSecret);
    final normalizedKey = _normalizeKey(combinedKey);

    final keyObj = encrypt.Key.fromUtf8(normalizedKey);
    _iv = encrypt.IV.fromUtf8(_generateIV(normalizedKey));
    _encrypter = encrypt.Encrypter(encrypt.AES(keyObj));

    _initialized = true;
  }

  Future<String> _getNativeKey() async {
    try {
      final key = await _methodChannel.invokeMethod<String>('getEncryptionKey');
      if (key == null || key.isEmpty) throw Exception('Native key not found');
      return key;
    } catch (e) {
      if (kDebugMode) print('[EncryptionService] Native key error: $e');
      throw Exception('Unable to get native encryption key');
    }
  }

  String _generateRandomSecret() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(values);
  }

  String _combineKeys(String nativeKey, String randomSecret) {
    final combined = base64.encode(utf8.encode('$nativeKey$randomSecret'));
    return combined.substring(0, 32);
  }

  String _normalizeKey(String key) =>
      key.length >= 32 ? key.substring(0, 32) : key.padRight(32, '0');

  String _generateIV(String key) => key.substring(0, 16);

  String encrypt(String plainText) {
    try {
      if (!_initialized) throw Exception('Service not initialized');
      if (plainText.isEmpty) return plainText;
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) print('[EncryptionService] Encryption error: $e');
      return plainText;
    }
  }

  String decrypt(String encryptedText) {
    try {
      if (!_initialized) throw Exception('Service not initialized');
      if (encryptedText.isEmpty) return encryptedText;
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      if (kDebugMode) print('[EncryptionService] Decryption error: $e');
      return encryptedText;
    }
  }
}
```

---

### ✅ Example Usage

```dart
final encryptionService = EncryptionService();

await encryptionService.initialize();

final encrypted = encryptionService.encrypt("Hello Secure World!");
print("Encrypted: $encrypted");

final decrypted = encryptionService.decrypt(encrypted);
print("Decrypted: $decrypted");
```

---

## 🗝️ 2. AppPrefEncryptedImpl

### Purpose

`AppPrefEncryptedImpl` wraps `SharedPreferences` and automatically encrypts/decrypts strings using `EncryptionService`.

---

### 🔧 Setup

Add dependencies if not already done:

```yaml
dependencies:
  shared_preferences: ^2.2.0
  encrypt: ^5.0.1
  flutter_secure_storage: ^9.0.0
```

---

### Flutter Implementation

`lib/prefs/app_pref_encrypted_impl.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/encryption_service.dart';
import 'app_pref.dart';
import 'app_pref_keys.dart';

class AppPrefEncryptedImpl implements AppPref {
  final SharedPreferences _prefs;
  final EncryptionService _encryptionService;

  AppPrefEncryptedImpl(
    this._prefs, {
    EncryptionService? encryptionService,
  }) : _encryptionService = encryptionService ?? EncryptionService();

  Future<void> initialize() async => await _encryptionService.initialize();

  SharedPreferences get _instance => _prefs;

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

  @override
  Future<bool> setThemeMode(String themeMode, {String? defaultValue}) async {
    final val = themeMode.isNotEmpty ? themeMode : (defaultValue ?? 'system');
    return _setEncrypted(AppPrefKeys.themeMode, val);
  }

  @override
  String getThemeMode() => _getDecrypted(AppPrefKeys.themeMode, 'system');

  @override
  Future<bool> setLocale(String localeCode, {String? defaultValue}) async {
    final val = localeCode.isNotEmpty ? localeCode : (defaultValue ?? 'en');
    return _setEncrypted(AppPrefKeys.locale, val);
  }

  @override
  String getLocale() => _getDecrypted(AppPrefKeys.locale, 'en');

  @override
  Future<bool> setOnboardingCompleted(bool completed, {bool? defaultValue}) async {
    return _instance.setBool(AppPrefKeys.onboardingCompleted, completed);
  }

  @override
  bool isOnboardingCompleted() =>
      _instance.getBool(AppPrefKeys.onboardingCompleted) ?? false;

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
  Future<bool> setStringList(String key, List<String> value, {List<String>? defaultValue}) async {
    final list = value.isNotEmpty ? value : (defaultValue ?? []);
    final encrypted = list.map((e) => _encryptionService.encrypt(e)).toList();
    return _instance.setStringList(key, encrypted);
  }

  @override
  List<String>? getStringList(String key) {
    final list = _instance.getStringList(key);
    if (list == null) return null;
    return list.map((e) => _encryptionService.decrypt(e)).toList();
  }

  @override
  Future<bool> remove(String key) async => _instance.remove(key);

  @override
  Future<bool> clear() async => _instance.clear();
}
```

---

### ✅ Example Initialization

```dart
final prefs = await SharedPreferences.getInstance();
final encryptionService = EncryptionService();
await encryptionService.initialize();

final appPref = AppPrefEncryptedImpl(prefs, encryptionService: encryptionService);
```

---

### 💡 Example Usage

```dart
await appPref.setToken("abc123");
print(appPref.getToken());

await appPref.setLocale("en");
print(appPref.getLocale());

await appPref.setThemeMode("dark");
print(appPref.getThemeMode());
```

---

## 🧠 Best Practices

- Always call `await encryptionService.initialize()` **before using** any encrypted preference.
- Do **not** hardcode sensitive keys in production.
- Use KeyStore/Keychain for native key management.
- Store only sensitive strings encrypted (booleans/ints are fine as plain).

---

## 🗂️ Recommended Structure

```
lib/
 ├── prefs/
 │    ├── app_pref.dart
 │    ├── app_pref_keys.dart
 │    └── app_pref_encrypted_impl.dart
 ├── storage/
 │    └── encryption_service.dart
 └── main.dart
```

---

© 2026 — Secure Preferences System by Hassan Mehmood
