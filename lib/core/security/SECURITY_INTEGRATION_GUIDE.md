# 🔒 Flutter App Security Integration Guide

Complete step-by-step guide to integrate comprehensive security checks (Root/Jailbreak, Emulator/Simulator, Developer Mode, Frida Detection) into any Flutter application.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Step 1: Android Setup](#step-1-android-setup)
4. [Step 2: iOS Setup](#step-2-ios-setup)
5. [Step 3: Flutter Implementation](#step-3-flutter-implementation)
6. [Step 4: Integration in Main App](#step-4-integration-in-main-app)
7. [Step 5: Testing](#step-5-testing)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)

---

## 🎯 Overview

This guide provides a complete security solution that detects:

- ✅ **Rooted Devices** (Android)
- ✅ **Jailbroken Devices** (iOS)
- ✅ **Emulators** (Android)
- ✅ **Simulators** (iOS)
- ✅ **Developer Mode** (Android)
- ✅ **Frida/Reverse Engineering Tools**
- ✅ **External Storage Installation** (Android)
- ✅ **Device Trust Issues**

---

## 📦 Prerequisites

### Required Packages

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  jailbreak_root_detection: ^2.0.0  # For additional Android checks
```

### Platform Requirements

- **Android**: Minimum SDK 21 (Android 5.0)
- **iOS**: Minimum iOS 12.0
- **Flutter**: Latest stable version

---

## 📱 Step 1: Android Setup

### 1.1 Update MainActivity.java

**Location:** `android/app/src/main/java/com/yourpackage/MainActivity.java`

Replace the entire file with:

```java
package com.yourpackage.yourapp;

import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "security_channel";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Security channel for iOS-style checks
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "checkRoot":
                                    result.success(isRooted());
                                    break;
                                case "checkEmulator":
                                    result.success(isEmulator());
                                    break;
                                case "checkDeveloperMode":
                                    result.success(isDeveloperModeEnabled());
                                    break;
                                default:
                                    result.notImplemented();
                            }
                        }
                );

        // Additional security channel (optional, for obfuscated checks)
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "qwe_rty_123")
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "a1":
                                    result.success(checkRootAdvanced());
                                    break;
                                case "b1":
                                    result.success(isEmulatorAdvanced());
                                    break;
                                case "c1":
                                    result.success(isDeveloperModeEnabled());
                                    break;
                                default:
                                    result.notImplemented();
                            }
                        }
                );
    }

    // ==================== Root Detection ====================

    /**
     * Comprehensive root detection using multiple methods
     */
    private boolean isRooted() {
        return checkRootBinaries() ||
               checkRootPackages() ||
               checkBuildTags() ||
               checkSystemMount() ||
               checkBusybox() ||
               checkXposed() ||
               checkMagisk() ||
               checkFridaFiles();
    }

    /**
     * Check for common root binary locations
     */
    private boolean checkRootBinaries() {
        String[] rootPaths = {
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/data/local/su",
            "/su/bin/su",
            "/vendor/bin/su"
        };
        
        for (String path : rootPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check for root management apps
     */
    private boolean checkRootPackages() {
        String[] rootPackages = {
            "com.noshufou.android.su",
            "com.noshufou.android.su.elite",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "com.topjohnwu.magisk",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "com.smedialink.oneclickroot",
            "com.zhiqupk.root.global",
            "com.alephzain.framaroot"
        };
        
        for (String packageName : rootPackages) {
            try {
                getPackageManager().getPackageInfo(packageName, 0);
                return true;
            } catch (Exception ignored) {
                // Package not found, continue
            }
        }
        return false;
    }

    /**
     * Check build tags for test-keys (indicates custom ROM)
     */
    private boolean checkBuildTags() {
        return Build.TAGS != null && Build.TAGS.contains("test-keys");
    }

    /**
     * Check if /system is mounted as read-write
     */
    private boolean checkSystemMount() {
        try {
            Process process = Runtime.getRuntime().exec("mount");
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream())
            );
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("/system") && line.contains("rw")) {
                    return true;
                }
            }
        } catch (Exception ignored) {
            // Error reading mount info
        }
        return false;
    }

    /**
     * Check for Busybox (common in rooted devices)
     */
    private boolean checkBusybox() {
        String[] busyboxPaths = {
            "/system/bin/busybox",
            "/system/xbin/busybox"
        };
        
        for (String path : busyboxPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check for Xposed Framework
     */
    private boolean checkXposed() {
        String[] xposedPaths = {
            "/system/framework/XposedBridge.jar",
            "/system/bin/app_process32_xposed",
            "/system/lib/libxposed_art.so"
        };
        
        for (String path : xposedPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check for Magisk (popular root solution)
     */
    private boolean checkMagisk() {
        String[] magiskPaths = {
            "/data/adb/magisk",
            "/sbin/.magisk",
            "/cache/.magisk",
            "/dev/.magisk",
            "/cache/magisk.log",
            "/data/adb/magisk.img",
            "/data/adb/magisk.db"
        };
        
        for (String path : magiskPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check for Frida files
     */
    private boolean checkFridaFiles() {
        String[] fridaPaths = {
            "/data/local/tmp/frida-server",
            "/system/lib/libfrida.so",
            "/system/lib64/libfrida.so"
        };
        
        for (String path : fridaPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    // ==================== Emulator Detection ====================

    /**
     * Comprehensive emulator detection
     */
    private boolean isEmulator() {
        return (Build.FINGERPRINT != null && (
                Build.FINGERPRINT.startsWith("generic") ||
                Build.FINGERPRINT.toLowerCase().contains("vbox") ||
                Build.FINGERPRINT.contains("test-keys")
            )) ||
            (Build.MODEL != null && (
                Build.MODEL.contains("Emulator") ||
                Build.MODEL.contains("Android SDK built for x86") ||
                Build.MODEL.contains("sdk")
            )) ||
            (Build.MANUFACTURER != null && (
                Build.MANUFACTURER.contains("Genymotion") ||
                Build.MANUFACTURER.contains("unknown")
            )) ||
            (Build.BRAND != null && Build.DEVICE != null &&
                Build.BRAND.startsWith("generic") &&
                Build.DEVICE.startsWith("generic")) ||
            (Build.PRODUCT != null && (
                Build.PRODUCT.contains("sdk") ||
                Build.PRODUCT.contains("emulator") ||
                Build.PRODUCT.contains("simulator")
            )) ||
            checkQemuFiles() ||
            checkEmulatorNetwork();
    }

    /**
     * Check for QEMU files (emulator indicators)
     */
    private boolean checkQemuFiles() {
        String[] qemuPaths = {
            "/dev/socket/qemud",
            "/dev/qemu_pipe",
            "/system/lib/libc_malloc_debug_qemu.so",
            "/sys/qemu_trace",
            "/system/bin/qemu-props"
        };
        
        for (String path : qemuPaths) {
            if (new File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check for emulator network (10.0.2.15 is default emulator IP)
     */
    private boolean checkEmulatorNetwork() {
        try {
            Process process = Runtime.getRuntime().exec("ip addr show");
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream())
            );
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("10.0.2.15")) {
                    return true;
                }
            }
        } catch (Exception ignored) {
            // Error reading network info
        }
        return false;
    }

    // ==================== Developer Mode Detection ====================

    /**
     * Check if USB debugging/Developer mode is enabled
     */
    private boolean isDeveloperModeEnabled() {
        try {
            int adbEnabled = Settings.Secure.getInt(
                getContentResolver(),
                Settings.Global.ADB_ENABLED,
                0
            );
            return adbEnabled != 0;
        } catch (Exception ignored) {
            return false;
        }
    }

    // ==================== Advanced/Obfuscated Checks ====================

    /**
     * Advanced root check (obfuscated method names)
     */
    private boolean checkRootAdvanced() {
        return checkRootBinaries() ||
               checkRootPackages() ||
               checkBuildTags() ||
               checkSystemMount() ||
               checkBusybox() ||
               checkXposed() ||
               checkMagisk() ||
               checkFridaProcesses() ||
               checkFridaPorts() ||
               checkFridaFiles();
    }

    /**
     * Check for running Frida processes
     */
    private boolean checkFridaProcesses() {
        try {
            Process process = Runtime.getRuntime().exec("ps");
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream())
            );
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("frida") || line.contains("gadget")) {
                    return true;
                }
            }
        } catch (Exception ignored) {
            // Error reading process list
        }
        return false;
    }

    /**
     * Check for Frida listening ports
     */
    private boolean checkFridaPorts() {
        try {
            Process process = Runtime.getRuntime().exec("netstat -an");
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream())
            );
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains(":27042") || line.contains(":27043")) {
                    return true;
                }
            }
        } catch (Exception ignored) {
            // Error reading network stats
        }
        return false;
    }

    /**
     * Advanced emulator check
     */
    private boolean isEmulatorAdvanced() {
        return isEmulator();
    }
}
```

### 1.2 Update AndroidManifest.xml

**Location:** `android/app/src/main/AndroidManifest.xml`

Add permissions (if not already present):

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Existing permissions -->
    
    <!-- Optional: Add if you need network checks -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="YourApp"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Your activity configuration -->
    </application>
</manifest>
```

---

## 🍎 Step 2: iOS Setup

### 2.1 Update AppDelegate.swift

**Location:** `ios/Runner/AppDelegate.swift`

Replace the entire file with:

```swift
import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let securityChannelName = "security_channel"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Flutter setup
        GeneratedPluginRegistrant.register(with: self)
        
        // Security Method Channel Setup
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        let securityChannel = FlutterMethodChannel(
            name: securityChannelName,
            binaryMessenger: controller.binaryMessenger
        )
        
        securityChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let strongSelf = self else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            switch call.method {
            case "checkJailbreak":
                result(strongSelf.isJailbroken())
            case "checkEmulator":
                result(strongSelf.isSimulator())
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Simulator Detection
    
    private func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Jailbreak Detection
    
    /// Comprehensive jailbreak detection using multiple independent checks
    private func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        // Combine multiple independent checks
        // If any returns true -> device likely jailbroken
        if hasSuspiciousFiles() { return true }
        if canWriteOutsideSandbox() { return true }
        if hasSuspiciousSymlinks() { return true }
        if hasInjectedLibraries() { return true }
        if sandboxIntegrityBroken() { return true }
        if canOpenJailbreakSchemes() { return true }
        return false
        #endif
    }
    
    // MARK: - Individual Jailbreak Checks
    
    /// Check for known jailbreak file paths using low-level access()
    private func hasSuspiciousFiles() -> Bool {
        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Applications/Sileo.app",
            "/Applications/Zebra.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/bin/bash",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/stash",
            "/usr/libexec/cydia",
            "/var/lib/cydia",
            "/usr/lib/frida",
            "/Library/MobileSubstrate/DynamicLibraries/FridaGadget.dylib",
            "/var/lib/frida"
        ]
        
        for path in suspiciousPaths {
            if access(path, F_OK) == 0 {
                print("Jailbreak artifact found at: \(path)")
                return true
            }
        }
        return false
    }
    
    /// Attempt to create a file outside sandbox (low-level open flags)
    private func canWriteOutsideSandbox() -> Bool {
        let testPath = "/private/jb_test_\(UUID().uuidString).txt"
        let fd = open(testPath, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        
        if fd != -1 {
            // File created successfully -> not sandboxed properly
            close(fd)
            unlink(testPath) // Try to remove created file
            print("Able to write outside sandbox at: \(testPath)")
            return true
        } else {
            // Could not create file -> normal sandbox behavior
            return false
        }
    }
    
    /// Check for symbolic links in common locations
    private func hasSuspiciousSymlinks() -> Bool {
        let suspiciousPaths = ["/Applications", "/usr/libexec", "/var/stash"]
        
        for path in suspiciousPaths {
            var statInfo = stat()
            if lstat(path, &statInfo) == 0 {
                // Check if it's a symbolic link
                let mode = statInfo.st_mode & S_IFMT
                if mode == S_IFLNK {
                    print("Suspicious symlink detected at: \(path)")
                    return true
                }
            }
        }
        return false
    }
    
    /// Check for injected libraries (DYLD environment variables)
    private func hasInjectedLibraries() -> Bool {
        if getenv("DYLD_INSERT_LIBRARIES") != nil {
            print("DYLD_INSERT_LIBRARIES present - possible library injection")
            return true
        }
        return false
    }
    
    /// Validate bundle path matches expected iOS sandbox layout
    private func sandboxIntegrityBroken() -> Bool {
        let bundlePath = Bundle.main.bundlePath
        // Typical app container path contains "/var/containers/"
        if !(bundlePath.contains("/var/containers/") || 
             bundlePath.contains("/private/var/containers/")) {
            print("Sandbox integrity suspicious - bundlePath: \(bundlePath)")
            return true
        }
        return false
    }
    
    /// Check if jailbreak URL schemes can be opened
    /// Note: Requires LSApplicationQueriesSchemes in Info.plist
    private func canOpenJailbreakSchemes() -> Bool {
        guard let app = UIApplication.shared as UIApplication? else {
            return false
        }
        
        let jailbreakSchemes = [
            "cydia://package/com.example.package",
            "sileo://package/com.example.package",
            "zebra://package/com.example.package"
        ]
        
        for scheme in jailbreakSchemes {
            if let url = URL(string: scheme), app.canOpenURL(url) {
                print("Can open jailbreak scheme: \(scheme)")
                return true
            }
        }
        return false
    }
}
```

### 2.2 Update Info.plist

**Location:** `ios/Runner/Info.plist`

Add URL schemes for jailbreak detection (if using scheme checks):

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>cydia</string>
    <string>sileo</string>
    <string>zebra</string>
</array>
```

---

## 📱 Step 3: Flutter Implementation

### 3.1 Create Security Service

**Location:** `lib/core/security/security_service.dart`

```dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

/// Comprehensive security service for device integrity checks
class SecurityService {
  // Method channels
  static const MethodChannel _securityChannel = MethodChannel('security_channel');
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
    // Check using jailbreak_root_detection package
    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRooted = await JailbreakRootDetection.instance.isJailBroken;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    final isOnExternalStorage = await JailbreakRootDetection.instance.isOnExternalStorage;
    final checkForIssues = await JailbreakRootDetection.instance.checkForIssues;
    final isDevMode = await JailbreakRootDetection.instance.isDevMode;

    // Check using native method channel
    final nativeRooted = await _checkRootNative();
    final nativeEmulator = await _checkEmulatorNative();
    final nativeDevMode = await _checkDeveloperModeNative();

    // Advanced checks (obfuscated channel)
    final advancedRoot = await _checkRootAdvanced();
    final advancedEmulator = await _checkEmulatorAdvanced();
    final advancedDevMode = await _checkDeveloperModeAdvanced();

    // Return true if ANY check fails
    return !isRealDevice ||
           isRooted ||
           isNotTrust ||
           isOnExternalStorage ||
           checkForIssues.isNotEmpty ||
           isDevMode ||
           nativeRooted ||
           nativeEmulator ||
           nativeDevMode ||
           advancedRoot ||
           advancedEmulator ||
           advancedDevMode;
  }

  static Future<String?> _getAndroidSecurityMessage() async {
    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRooted = await JailbreakRootDetection.instance.isJailBroken;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    final isOnExternalStorage = await JailbreakRootDetection.instance.isOnExternalStorage;
    final checkForIssues = await JailbreakRootDetection.instance.checkForIssues;
    final isDevMode = await JailbreakRootDetection.instance.isDevMode;

    if (isRooted) {
      return "Your device is rooted. You cannot access this application.";
    } else if (!isRealDevice) {
      return "You are currently running the application on an emulator. You cannot access this application.";
    } else if (isOnExternalStorage) {
      return "Your device is not trusted. You cannot access this application.";
    } else if (checkForIssues.isNotEmpty) {
      return "Your device is not trusted. You cannot access this application.";
    } else if (isDevMode) {
      return "Your device has developer mode enabled. You cannot access this application.";
    } else if (isNotTrust) {
      return "Your device is not trusted. You cannot access this application.";
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
        final result = await _securityChannel.invokeMethod<bool>('checkJailbreak');
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
        final result = await _securityChannel.invokeMethod<bool>('checkEmulator');
        return result ?? false;
      } else if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>('checkEmulator');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
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
      final result = await _securityChannel.invokeMethod<bool>('checkJailbreak');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check for developer mode (Android only)
  static Future<bool> _checkDeveloperModeNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>('checkDeveloperMode');
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
```

### 3.2 Create Security Widget

**Location:** `lib/core/security/security_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'security_service.dart';

/// Widget that blocks app access if device is compromised
class SecurityGate extends StatefulWidget {
  final Widget child;
  final Widget? blockedWidget;

  const SecurityGate({
    Key? key,
    required this.child,
    this.blockedWidget,
  }) : super(key: key);

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _isChecking = true;
  bool _isCompromised = false;
  String? _securityMessage;

  @override
  void initState() {
    super.initState();
    _performSecurityCheck();
  }

  Future<void> _performSecurityCheck() async {
    final isCompromised = await SecurityService.isDeviceCompromised();
    final message = await SecurityService.getSecurityMessage();

    setState(() {
      _isCompromised = isCompromised;
      _securityMessage = message;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isCompromised) {
      return widget.blockedWidget ?? _defaultBlockedWidget();
    }

    return widget.child;
  }

  Widget _defaultBlockedWidget() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _securityMessage ?? 'Your device does not meet security requirements.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Optionally retry check
                  _performSecurityCheck();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🚀 Step 4: Integration in Main App

### 4.1 Update main.dart

**Location:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'core/security/security_widget.dart';
import 'features/app/presentation/pages/flutter_sample_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      // Wrap your app with SecurityGate
      home: SecurityGate(
        child: const FlutterSampleApp(),
        // Optional: Custom blocked widget
        // blockedWidget: CustomSecurityBlockedWidget(),
      ),
    );
  }
}
```

### 4.2 Alternative: Check Before App Initialization

If you want to check security before initializing the app:

```dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'core/security/security_service.dart';
import 'features/app/presentation/pages/flutter_sample_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Perform security check before app initialization
  final isCompromised = await SecurityService.isDeviceCompromised();
  
  if (isCompromised) {
    // Exit app or show error
    final message = await SecurityService.getSecurityMessage();
    print('Security check failed: $message');
    exit(0); // Exit app
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      home: const FlutterSampleApp(),
    );
  }
}
```

---

## 🧪 Step 5: Testing

### 5.1 Test on Real Devices

1. **Test on Normal Device**
   - Should pass all checks
   - App should work normally

2. **Test on Rooted Device (Android)**
   - Install on rooted device
   - App should be blocked

3. **Test on Jailbroken Device (iOS)**
   - Install on jailbroken device
   - App should be blocked

### 5.2 Test on Emulators/Simulators

1. **Android Emulator**
   - Run app on Android emulator
   - App should be blocked

2. **iOS Simulator**
   - Run app on iOS simulator
   - App should be blocked

### 5.3 Test Developer Mode

1. **Android**
   - Enable USB debugging
   - App should be blocked (if enabled)

---

## 🔧 Troubleshooting

### Issue: Method Channel Not Working

**Solution:**
- Ensure channel names match exactly in native and Dart code
- Check that `configureFlutterEngine` is called
- Verify platform-specific code is in correct directories

### Issue: Package Not Found (jailbreak_root_detection)

**Solution:**
```bash
flutter pub get
```

If package doesn't exist, you can remove those checks and rely only on native channels.

### Issue: iOS Build Fails

**Solution:**
- Ensure `Info.plist` has correct URL schemes
- Check that AppDelegate.swift is properly formatted
- Clean and rebuild: `flutter clean && flutter pub get`

### Issue: Android Build Fails

**Solution:**
- Ensure MainActivity.java package name matches your app
- Check that all imports are correct
- Clean and rebuild: `flutter clean && flutter pub get`

---

## ✅ Best Practices

### 1. **Fail-Safe Default**

Always assume compromised on error:
```dart
catch (e) {
  return true; // Fail-safe: block on error
}
```

### 2. **Multiple Checks**

Use multiple independent checks:
- Package-based detection
- Native method channels
- File system checks
- Process checks

### 3. **Performance**

- Cache security check results
- Run checks asynchronously
- Don't block UI thread

### 4. **User Experience**

- Show clear error messages
- Provide retry option
- Don't reveal detection methods

### 5. **Regular Updates**

- Update detection methods regularly
- Monitor new bypass techniques
- Keep dependencies updated

### 6. **Server-Side Validation**

- Validate device status on server
- Use device attestation APIs
- Implement rate limiting

---

## 📝 Summary

This integration provides:

✅ **Comprehensive Security Checks**
- Root/Jailbreak detection
- Emulator/Simulator detection
- Developer mode detection
- Frida detection
- Multiple detection methods

✅ **Easy Integration**
- Simple widget wrapper
- Clear error messages
- Retry functionality

✅ **Production Ready**
- Fail-safe defaults
- Error handling
- Performance optimized

✅ **Cross-Platform**
- Android and iOS support
- Unified API
- Platform-specific optimizations

---

**Note:** Security is a cat-and-mouse game. Regularly update your detection methods and stay informed about new bypass techniques. This implementation provides a strong foundation, but should be part of a comprehensive security strategy.
