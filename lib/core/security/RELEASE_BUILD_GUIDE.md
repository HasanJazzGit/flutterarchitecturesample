# 📦 Release Build Guide

Complete guide for building and running release APK/IPA with security checks enabled.

---

## 📋 Table of Contents

1. [Android Release Build](#android-release-build)
2. [iOS Release Build](#ios-release-build)
3. [Installation Methods](#installation-methods)
4. [Testing Security Checks](#testing-security-checks)
5. [Troubleshooting](#troubleshooting)

---

## 🤖 Android Release Build

### Build Release APK

```bash
# Standard release APK
flutter build apk --release

# Split APKs by ABI (smaller file size)
flutter build apk --release --split-per-abi

# App Bundle for Play Store
flutter build appbundle --release
```

### APK Locations

- **Single APK:** `build/app/outputs/flutter-apk/app-release.apk`
- **Split APKs:** 
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
  - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
  - `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### Run Release APK on Device

#### Method 1: Direct Install (Recommended)

```bash
# Build and install in one command
flutter install --release

# Or build first, then install
flutter build apk --release
flutter install --release
```

#### Method 2: Using ADB

```bash
# Check connected devices
adb devices

# Install APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Install with replacement (if app already installed)
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

#### Method 3: Manual Installation

1. **Transfer APK to device:**
   - Copy `build/app/outputs/flutter-apk/app-release.apk` to your device
   - Use USB, email, cloud storage, or file sharing

2. **Enable Unknown Sources:**
   - Go to Settings → Security → Unknown Sources (or Install Unknown Apps)
   - Enable for your file manager/email app

3. **Install:**
   - Open the APK file on your device
   - Tap "Install"
   - Wait for installation to complete

---

## 🍎 iOS Release Build

### Build Release IPA

```bash
# Build for device
flutter build ios --release

# Build IPA (requires Xcode)
flutter build ipa --release
```

### IPA Location

- **IPA:** `build/ios/ipa/*.ipa`

### Install on iOS Device

#### Method 1: Using Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your device from device list
3. Product → Archive
4. Distribute App → Development/Ad Hoc
5. Install on connected device

#### Method 2: Using TestFlight

1. Upload IPA to App Store Connect
2. Add device to TestFlight
3. Install via TestFlight app

#### Method 3: Using Ad Hoc Distribution

1. Build IPA with ad hoc provisioning profile
2. Install via iTunes/Finder or Apple Configurator

---

## 🚀 Quick Commands

### Android

```bash
# Build release APK
flutter build apk --release

# Build and install on connected device
flutter install --release

# Build split APKs (smaller size)
flutter build apk --release --split-per-abi

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build release iOS
flutter build ios --release

# Build IPA
flutter build ipa --release

# Run on connected device (requires Xcode setup)
flutter run --release
```

---

## 🧪 Testing Security Checks

### View Security Logs

#### Android (ADB Logcat)

```bash
# View all security logs
adb logcat | grep Security

# View only security-related logs
adb logcat -s Security:D

# Save logs to file
adb logcat | grep Security > security_logs.txt
```

#### iOS (Xcode Console)

1. Connect device to Mac
2. Open Xcode → Window → Devices and Simulators
3. Select your device
4. View console logs

### Expected Behavior

#### On Real Device (Should Pass)
```
D/Security: Root check: false
D/Security: Emulator check: false
D/Security: Developer mode check: true/false
I/flutter: [Security] Device compromised: false
```
**Result:** App should work normally ✅

#### On Emulator (Should Block)
```
D/Security: Root check: false
D/Security: Emulator check: true
D/Security: FINGERPRINT: google/sdk_gphone64_arm64/...
D/Security: MODEL: sdk_gphone64_arm64
D/Security: HARDWARE: ranchu
I/flutter: [Security] Device compromised: true
```
**Result:** App should show "Access Denied" screen ❌

#### On Rooted Device (Should Block)
```
D/Security: Root check: true
D/Security: Emulator check: false
I/flutter: [Security] Device compromised: true
```
**Result:** App should show "Access Denied" screen ❌

---

## 🔍 Debugging Release Builds

### Enable Debug Logging in Release

**Note:** Remove debug prints before production!

For testing, you can temporarily enable logging:

```dart
// In security_service.dart
static Future<bool> _checkAndroidSecurity() async {
  // ... checks ...
  
  // Debug logging (remove in production)
  if (kDebugMode) {
    print('[Security] Root: $nativeRooted, Emulator: $nativeEmulator');
  }
  
  return isCompromised;
}
```

### Check Build Configuration

```bash
# Verify release build
flutter build apk --release --verbose

# Check APK info
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Installation Troubleshooting

### Android Issues

#### "App not installed" Error

**Solutions:**
1. Uninstall existing debug version first:
   ```bash
   adb uninstall com.example.fluttersampleachitecture
   ```

2. Check APK signature:
   ```bash
   jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
   ```

3. Check device storage space

4. Enable "Install from Unknown Sources"

#### "Package conflicts with existing package"

**Solution:**
```bash
# Uninstall existing app
adb uninstall com.example.fluttersampleachitecture

# Reinstall
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### APK Installation Fails

**Check:**
- Device architecture matches APK (arm64, arm32, x86_64)
- Minimum Android version requirement
- Storage space available

**Use split APKs:**
```bash
flutter build apk --release --split-per-abi
# Install the correct ABI for your device
```

### iOS Issues

#### "Untrusted Developer" Error

**Solution:**
1. Settings → General → Device Management
2. Trust your developer certificate

#### Code Signing Errors

**Solution:**
1. Open Xcode → Signing & Capabilities
2. Select proper team and provisioning profile
3. Ensure device is registered in Apple Developer Portal

---

## ✅ Verification Checklist

After installing release build:

- [ ] App launches successfully on real device
- [ ] Security checks pass (no false positives)
- [ ] App works normally (not blocked)
- [ ] Logs show correct security status
- [ ] Emulator detection works (if tested)
- [ ] Root detection works (if tested)

---

## 🎯 Best Practices

### 1. **Test Before Release**

```bash
# Test on real device first
flutter install --release

# Verify security checks
adb logcat | grep Security
```

### 2. **Remove Debug Logging**

Before production release:
- Remove all `print()` statements
- Remove debug logging from security checks
- Use proper logging framework (e.g., `logger` package)

### 3. **Obfuscate Code**

```bash
# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

### 4. **Test Multiple Devices**

- Test on different Android versions
- Test on different manufacturers
- Verify no false positives

---

## 📝 Summary

### Quick Reference

**Build Release APK:**
```bash
flutter build apk --release
```

**Install on Device:**
```bash
flutter install --release
# OR
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Check Logs:**
```bash
adb logcat | grep Security
```

**APK Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

---

**Note:** Always test release builds on real devices before distributing to ensure security checks work correctly and don't block legitimate users.
