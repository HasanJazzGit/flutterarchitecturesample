import 'package:flutter/services.dart';

class NativeSecurity {
  // ⚠️ Make sure this matches the native code exactly
  static const _channel = MethodChannel('com.example.fluttersampleachitecture/security');

  static Future<String> getSecretKey() async {
    try {
      final key = await _channel.invokeMethod<String>('getSecretKey');
      return key ?? '';
    } catch (e) {
      print('Error fetching secret key: $e');
      return '';
    }
  }
}
