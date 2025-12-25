import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;

/// Service for encrypting and decrypting data
/// Uses AES encryption with a secure key
class EncryptionService {
  static const String _defaultKey = String.fromEnvironment('Pref_Key'); // 32 chars for AES-256
  static const String _defaultIV = '1234567890123456'; // 16 chars for IV

  late Encrypter _encrypter;
  late IV _iv;

  /// Initialize encryption service with optional key and IV
  /// If not provided, uses default values (not recommended for production)
  EncryptionService({String? encryptionKey, String? iv}) {
    // Use provided key or default (pad/truncate to 32 chars)
    final key = _normalizeKey(encryptionKey ?? _defaultKey);
    final keyObj = Key.fromBase64(base64Encode(utf8.encode(key)));

    // Use provided IV or default (pad/truncate to 16 chars)
    final ivString = _normalizeIV(iv ?? _defaultIV);
    _iv = IV.fromBase64(base64Encode(utf8.encode(ivString)));

    _encrypter = Encrypter(AES(keyObj));
  }

  /// Update encryption key and IV
  /// This will reinitialize the encrypter with new values
  void updateKeyAndIV({String? encryptionKey, String? iv}) {
    // Use provided key or keep current
    final key = encryptionKey != null
        ? _normalizeKey(encryptionKey)
        : _normalizeKey(_defaultKey);
    final keyObj = Key.fromBase64(base64Encode(utf8.encode(key)));

    // Use provided IV or keep current
    final ivString = iv != null ? _normalizeIV(iv) : _normalizeIV(_defaultIV);
    _iv = IV.fromBase64(base64Encode(utf8.encode(ivString)));

    _encrypter = Encrypter(AES(keyObj));
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

  /// Encrypt a string value
  /// Returns base64 encoded encrypted string
  String encrypt(String plainText) {
    try {
      if (plainText.isEmpty) return plainText;
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) {
        print('[EncryptionService] Encryption error: $e');
      }
      // Return original if encryption fails
      return plainText;
    }
  }

  /// Decrypt an encrypted string
  /// Expects base64 encoded encrypted string
  String decrypt(String encryptedText) {
    try {
      if (encryptedText.isEmpty) return encryptedText;
      final encrypted = Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      if (kDebugMode) {
        print('[EncryptionService] Decryption error: $e');
      }
      // Return original if decryption fails (might be unencrypted data)
      return encryptedText;
    }
  }

  /// Check if a string is encrypted (base64 format check)
  bool isEncrypted(String value) {
    try {
      if (value.isEmpty) return false;
      // Try to decode as base64
      base64Decode(value);
      // If it decodes successfully, assume it might be encrypted
      // This is a simple check - encrypted values are typically base64
      return value.length > 16; // Encrypted values are usually longer
    } catch (e) {
      return false;
    }
  }
}
