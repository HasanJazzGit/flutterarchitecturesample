import 'package:flutter/services.dart';

class NativeSecurity {
  // ⚠️ Make sure this matches the native code exactly
  static const platform = MethodChannel("native/keys");

  static Future<String> getSecretKey() async {
    try {
      final key = await platform.invokeMethod<String>('getSecretKey');
      return key ?? '';
    } catch (e) {
      print('Error fetching secret key: $e');
      return '';
    }
  }



}
