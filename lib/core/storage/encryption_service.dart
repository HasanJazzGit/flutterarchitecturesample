import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as dev;

import '../security/native_security.dart';


class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Constants
  static const String _secretKeyName = 'app_random_secret_key';

  // Dependencies
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late String _nativeKey; // Key from method channel
  late String _randomSecret; // Random key stored in secure storage
  late String _combinedKey; // Combined key
  late String _normalizedKey; // Normalized key


  bool _initialized = false;

  /// Initialize encryption keys and setup
  Future<void> initialize() async {
    if (_initialized) {
      if (kDebugMode) print('[EncryptionService] Already initialized — skipping.');
      return;
    }

    if (kDebugMode) print('[EncryptionService] Initializing encryption service...');

    // 1️⃣ Get native key from platform side
    _nativeKey = await _getNativeKey();
    if (kDebugMode) print('[EncryptionService] Native key fetched successfully.');

    // 2️⃣ Retrieve or create random secret
    String? storedSecret = await _secureStorage.read(key: _secretKeyName);
    if (storedSecret == null) {
      storedSecret = _generateRandomSecret();
      await _secureStorage.write(key: _secretKeyName, value: storedSecret);
      if (kDebugMode) print('[EncryptionService] Random secret key generated and stored.');
    } else {
      if (kDebugMode) print('[EncryptionService] Random secret key loaded from secure storage.');
    }
    _randomSecret = storedSecret;

    // 3️⃣ Combine both keys
    _combinedKey = _combineKeys(_nativeKey, _randomSecret);
     _normalizedKey = _normalizeKey(_combinedKey);

    _initialized = true;
    if (kDebugMode) {
      print('[EncryptionService] Initialization complete ✅');
      print('[EncryptionService] CombinedKey (len=${_normalizedKey.length}): $_normalizedKey');
    }
  }

  /// Fetch native key via platform channel
  Future<String> _getNativeKey() async {
    try {
      if (kDebugMode) print('[EncryptionService] Requesting native key from platform...');
      final key = await NativeSecurity.getSecretKey();
      if (key.isEmpty) throw Exception('Native key not found');
      return key;
    } catch (e) {
      if (kDebugMode) print('[EncryptionService] ❌ Failed to get native key: $e');
      throw Exception('Unable to retrieve native encryption key');
    }
  }

  /// Generate a secure random 32-byte secret key
  String _generateRandomSecret() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final secret = base64Encode(values);
    if (kDebugMode) print('[EncryptionService] Generated new random secret (Base64 length: ${secret.length})');
    return secret;
  }

  /// Combine native and random secrets into a strong key
  String _combineKeys(String nativeKey, String randomSecret) {
    final combined = base64.encode(utf8.encode('$nativeKey$randomSecret'));
    if (kDebugMode) print('[EncryptionService] Keys combined. Combined Base64 length: ${combined.length}');
    return combined.substring(0, 32);
  }

  /// Normalize to 32 characters (AES-256 key)
  String _normalizeKey(String key) {
    final normalized = key.length >= 32 ? key.substring(0, 32) : key.padRight(32, '0');
    if (kDebugMode) print('[EncryptionService] Normalized key length: ${normalized.length}');
    return normalized;
  }


  String encrypt(String plainText) {
    final key = utf8.encode(_normalizedKey);
    final bytes = utf8.encode(plainText);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);

    final random = Random.secure();
    final iv = List<int>.generate(16, (i) => random.nextInt(256));
    final encrypted = _xorEncrypt(bytes, iv);

    final base64Payload = base64Encode([...iv, ...encrypted]);
    final result = '$base64Payload:$digest';

    // Log encrypted text and lengths
    dev.log('Encrypted Text: $result', name: 'EncryptionService');
    dev.log('Encrypted Text Length: ${result.length}', name: 'EncryptionService');
    dev.log('Base64 Payload: $base64Payload', name: 'EncryptionService');
    dev.log('Base64 Payload Length: ${base64Payload.length}', name: 'EncryptionService');

    return result;
  }

  String decrypt(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) return '';

      final data = base64Decode(parts[0]);
      final storedDigest = parts[1];

      final iv = data.sublist(0, 16);
      final encrypted = data.sublist(16);

      final decrypted = _xorDecrypt(encrypted, iv);

      final key = utf8.encode(_normalizedKey);
      final hmac = Hmac(sha256, key);
      final calculatedDigest = hmac.convert(decrypted).toString();

      if (calculatedDigest != storedDigest) return '';

      final result = utf8.decode(decrypted);

      // Log decrypted text and its length
      dev.log('Decrypted Text: $result', name: 'EncryptionService');
      dev.log('Decrypted Text Length: ${result.length}', name: 'EncryptionService');

      return result;
    } catch (e) {
      return '';
    }
  }
// XOR helpers
  List<int> _xorEncrypt(List<int> data, List<int> key) {
    final result = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    return result;
  }

  List<int> _xorDecrypt(List<int> data, List<int> key) => _xorEncrypt(data, key);
  String obfuscateKey(String keyName) {
    final input = keyName + _nativeKey+_randomSecret;
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    return base64Encode(hash.bytes).substring(0, 20).replaceAll(RegExp(r'[+/=]'), '_');
  }
}
