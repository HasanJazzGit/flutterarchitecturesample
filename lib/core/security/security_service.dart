import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../flavor/app_config.dart';
import '../flavor/app_flavor.dart';

/// Comprehensive security service for device integrity checks
class SecurityService {
  // Method channels
  static const MethodChannel _securityChannel = MethodChannel(
    'security_channel',
  );
  static const MethodChannel _advancedChannel = MethodChannel('qwe_rty_123');

  /// Perform all security checks and return true if device is compromised
  static Future<bool> isDeviceCompromised() async {
    try {
      if (Platform.isAndroid) {
        return await _checkAndroidSecurity();
      } else if (Platform.isIOS) {
        return await _checkIOSSecurity();
      }
      return false;
    } catch (e) {
      // On error, assume compromised (fail-safe)
      return true;
    }
  }

  /// Get detailed security status message
  static Future<String?> getSecurityMessage() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidSecurityMessage();
      } else if (Platform.isIOS) {
        return await _getIOSSecurityMessage();
      }
      return null;
    } catch (e) {
      return "Security check failed. Please contact support.";
    }
  }

  // ==================== Android Security Checks ====================

  static Future<bool> _checkAndroidSecurity() async {
    // Check using native method channel
    final nativeRooted = await _checkRootNative();
    final nativeEmulator = await _checkEmulatorNative();

    // Developer mode check - only enforce in production
    final shouldCheckDevMode = AppConfig.currentFlavor == AppFlavor.production;
    final nativeDevMode = shouldCheckDevMode
        ? await _checkDeveloperModeNative()
        : false;

    // Advanced checks (obfuscated channel)
    final advancedRoot = await _checkRootAdvanced();
    final advancedEmulator = await _checkEmulatorAdvanced();
    final advancedDevMode = shouldCheckDevMode
        ? await _checkDeveloperModeAdvanced()
        : false;

    // Debug logging (remove in production or use proper logging)
    if (kDebugMode) {
      print(
        '[Security] Root: $nativeRooted, Emulator: $nativeEmulator, DevMode: $nativeDevMode (checked: $shouldCheckDevMode)',
      );
      print(
        '[Security] Advanced - Root: $advancedRoot, Emulator: $advancedEmulator, DevMode: $advancedDevMode',
      );
      print('[Security] Current Flavor: ${AppConfig.currentFlavor.name}');
    }

    // Return true if ANY check fails
    final isCompromised =
        nativeRooted ||
        nativeEmulator ||
        nativeDevMode ||
        advancedRoot ||
        advancedEmulator ||
        advancedDevMode;

    if (kDebugMode) {
      print('[Security] Device compromised: $isCompromised');
    }
    return isCompromised;
  }

  static Future<String?> _getAndroidSecurityMessage() async {
    final nativeRooted = await _checkRootNative();
    final nativeEmulator = await _checkEmulatorNative();
    final nativeDevMode = await _checkDeveloperModeNative();

    if (nativeRooted) {
      return "Your device is rooted. You cannot access this application.";
    } else if (nativeEmulator) {
      return "You are currently running the application on an emulator. You cannot access this application.";
    } else if (nativeDevMode) {
      return "Your device has developer mode enabled. You cannot access this application.";
    }

    return null;
  }

  // ==================== iOS Security Checks ====================

  static Future<bool> _checkIOSSecurity() async {
    try {
      final jailbroken = await _checkJailbreakNative();
      final simulator = await _checkSimulatorNative();

      return jailbroken || simulator;
    } on PlatformException catch (e) {
      // On error, assume compromised (fail-safe)
      return true;
    }
  }

  static Future<String?> _getIOSSecurityMessage() async {
    try {
      final jailbroken = await _checkJailbreakNative();
      final simulator = await _checkSimulatorNative();

      if (jailbroken) {
        return "Your device is jailbroken. You cannot access this application.";
      } else if (simulator) {
        return "You are currently running the application on a simulator. You cannot access this application.";
      }

      return null;
    } on PlatformException catch (e) {
      return "Security check failed. Please contact support.";
    }
  }

  // ==================== Native Method Channel Calls ====================

  /// Check for root (Android) / jailbreak (iOS) via native channel
  static Future<bool> _checkRootNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>('checkRoot');
        return result ?? false;
      } else if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkJailbreak',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check for emulator (Android) / simulator (iOS) via native channel
  static Future<bool> _checkEmulatorNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkEmulator',
        );
        print('[Security] Native emulator check result: $result');
        return result ?? false;
      } else if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkEmulator',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      print('[Security] Error checking emulator: $e');
      // Fail-safe: assume emulator on error
      return true;
    }
  }

  static Future<bool> _checkSimulatorNative() async {
    try {
      final result = await _securityChannel.invokeMethod<bool>('checkEmulator');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkJailbreakNative() async {
    try {
      final result = await _securityChannel.invokeMethod<bool>(
        'checkJailbreak',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check for developer mode (Android only)
  static Future<bool> _checkDeveloperModeNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkDeveloperMode',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== Advanced/Obfuscated Checks ====================

  static Future<bool> _checkRootAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('a1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkEmulatorAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('b1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkDeveloperModeAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('c1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
