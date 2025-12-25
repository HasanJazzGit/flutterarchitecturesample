# 🌐 Release Build Network Guide

Guide for ensuring network connectivity works correctly in release builds.

---

## 📋 Table of Contents

1. [Network Permissions](#network-permissions)
2. [Android Configuration](#android-configuration)
3. [iOS Configuration](#ios-configuration)
4. [Troubleshooting](#troubleshooting)
5. [Testing Network in Release](#testing-network-in-release)

---

## ✅ Network Permissions

### Android

**Location:** `android/app/src/main/AndroidManifest.xml`

The INTERNET permission is already configured:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application>
        <!-- Your app configuration -->
    </application>
</manifest>
```

✅ **Status:** Internet permission is properly declared.

### iOS

**Location:** `ios/Runner/Info.plist`

iOS doesn't require explicit INTERNET permission declaration. Network access is allowed by default.

---

## 🔧 Android Configuration

### Network Security Configuration (Optional)

If you need to allow cleartext traffic (HTTP) or configure network security:

**Create:** `android/app/src/main/res/xml/network_security_config.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- Allow cleartext traffic for development (remove in production) -->
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    
    <!-- Production: Only HTTPS -->
    <!--
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    -->
</network-security-config>
```

**Add to AndroidManifest.xml:**

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
</application>
```

**Note:** Only add this if you need HTTP (cleartext) traffic. For production, always use HTTPS.

---

## 🍎 iOS Configuration

### App Transport Security (ATS)

**Location:** `ios/Runner/Info.plist`

For production, ATS is enabled by default (HTTPS only). If you need HTTP:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**⚠️ Warning:** Only use this for development. Production should use HTTPS only.

---

## 🧪 Testing Network in Release

### 1. Check Network Permissions

```bash
# Check if app has internet permission
adb shell dumpsys package com.example.fluttersampleachitecture | grep permission
```

### 2. Test API Calls

```bash
# Monitor network traffic
adb logcat | grep -i "network\|http\|api"

# Or use tcpdump
adb shell tcpdump -i any -p -s 0 -w /sdcard/capture.pcap
```

### 3. Test Connectivity Service

The app already has `ConnectivityService`:

```dart
import 'package:fluttersampleachitecture/core/utils/connectivity_service.dart';

// Check connectivity
final connectivityService = ConnectivityService();
final hasInternet = await connectivityService.hasInternetConnection();
print('Has internet: $hasInternet');
```

---

## 🔍 Troubleshooting

### Issue: No Internet in Release Build

#### Check 1: Verify Permissions

```bash
# Check AndroidManifest.xml has INTERNET permission
grep -r "INTERNET" android/app/src/main/AndroidManifest.xml
```

#### Check 2: Network Security Configuration

If using HTTP (not HTTPS), ensure network security config allows cleartext:

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

#### Check 3: API Base URL

Verify the API URL is correct for release:

```dart
// Check current API URL
print('API URL: ${AppConfig.getBaseUrl()}');
```

#### Check 4: Firewall/Proxy

- Check device firewall settings
- Check if corporate proxy is blocking requests
- Verify device has internet connectivity

#### Check 5: Certificate Issues

If using self-signed certificates or custom CAs:

```xml
<!-- network_security_config.xml -->
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">your-api.com</domain>
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" /> <!-- For custom CAs -->
        </trust-anchors>
    </domain-config>
</network-security-config>
```

---

## 📱 Common Issues

### 1. "Network request failed" in Release

**Causes:**
- Missing INTERNET permission
- Network security config blocking requests
- Incorrect API URL
- Certificate pinning issues

**Solution:**
1. Verify `AndroidManifest.xml` has INTERNET permission
2. Check network security configuration
3. Verify API URLs are correct
4. Test with `adb logcat` to see error details

### 2. HTTP Not Working (Only HTTPS)

**Cause:** Android 9+ blocks cleartext traffic by default.

**Solution:**
- Use HTTPS (recommended)
- Or configure network security config (development only)

### 3. API Calls Timeout

**Causes:**
- Network connectivity issues
- Firewall blocking
- Incorrect timeout configuration

**Solution:**
```dart
// Increase timeout in ApiClient
final apiClient = ApiClient(
  config: ApiClientConfig(
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ),
);
```

---

## ✅ Verification Checklist

- [ ] INTERNET permission in AndroidManifest.xml
- [ ] Network security config (if using HTTP)
- [ ] API URLs are correct for release
- [ ] Test API calls in release build
- [ ] Check network logs with `adb logcat`
- [ ] Verify device has internet connectivity
- [ ] Test on real device (not emulator)

---

## 🎯 Quick Fixes

### If Network Doesn't Work in Release:

1. **Verify Permission:**
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

2. **Check API URL:**
   ```dart
   print('API Base URL: ${AppConfig.getBaseUrl()}');
   ```

3. **Test Connectivity:**
   ```dart
   final hasInternet = await ConnectivityService().hasInternetConnection();
   ```

4. **Check Logs:**
   ```bash
   adb logcat | grep -i "network\|http\|dio"
   ```

---

## 📝 Summary

Your app already has:
- ✅ INTERNET permission configured
- ✅ ConnectivityService for checking network
- ✅ ApiClient with proper configuration

**If network doesn't work in release:**
1. Check device internet connectivity
2. Verify API URLs are correct
3. Check `adb logcat` for network errors
4. Ensure no firewall/proxy is blocking

The network should work in release builds. If you're experiencing issues, check the logs to identify the specific problem.
