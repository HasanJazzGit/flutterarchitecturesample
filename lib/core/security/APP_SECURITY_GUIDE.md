# 🔒 Flutter App Security Guide

Comprehensive guide for securing Flutter applications against reverse engineering, tampering, and unauthorized access.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Frida Detection](#frida-detection)
3. [Root Detection (Android)](#root-detection-android)
4. [Jailbreak Detection (iOS)](#jailbreak-detection-ios)
5. [App Integrity Checks](#app-integrity-checks)
6. [Certificate Pinning](#certificate-pinning)
7. [Code Obfuscation](#code-obfuscation)
8. [Anti-Tampering](#anti-tampering)
9. [Implementation Examples](#implementation-examples)
10. [Best Practices](#best-practices)

---

## 🎯 Overview

### Security Threats

1. **Frida** - Dynamic instrumentation toolkit for reverse engineering
2. **Root/Jailbreak** - Unauthorized device modifications
3. **App Tampering** - Modified APK/IPA files
4. **SSL Pinning Bypass** - Network interception
5. **Code Injection** - Runtime code modification

### Defense Strategy

- ✅ Detect and prevent Frida hooks
- ✅ Detect rooted/jailbroken devices
- ✅ Verify app integrity (signature, checksum)
- ✅ Implement certificate pinning
- ✅ Obfuscate code
- ✅ Add anti-tampering checks

---

## 🛡️ Frida Detection

### What is Frida?

Frida is a dynamic instrumentation toolkit that allows:
- Runtime code injection
- Function hooking
- Memory manipulation
- API interception

### Detection Methods

#### 1. **Check for Frida Server Process**

**Android (Native - MainActivity.kt):**
```kotlin
import android.os.Process
import java.io.BufferedReader
import java.io.FileReader

class SecurityChecker {
    companion object {
        fun isFridaRunning(): Boolean {
            return try {
                val processes = File("/proc/${Process.myPid()}/maps").readText()
                processes.contains("frida") || 
                processes.contains("gadget") ||
                processes.contains("re.frida")
            } catch (e: Exception) {
                false
            }
        }
        
        fun checkFridaProcesses(): Boolean {
            val suspiciousProcesses = listOf(
                "frida-server",
                "frida-agent",
                "gum-js-loop",
                "linjector"
            )
            
            return try {
                val process = Runtime.getRuntime().exec("ps")
                val reader = BufferedReader(process.inputStream.reader())
                val output = reader.readText()
                
                suspiciousProcesses.any { output.contains(it, ignoreCase = true) }
            } catch (e: Exception) {
                false
            }
        }
    }
}
```

**iOS (Native - AppDelegate.swift):**
```swift
import Foundation

class SecurityChecker {
    static func isFridaRunning() -> Bool {
        // Check for Frida processes
        let task = Process()
        task.launchPath = "/usr/bin/ps"
        task.arguments = ["-A"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        return output.contains("frida") || 
               output.contains("gadget") ||
               output.contains("re.frida")
    }
    
    static func checkFridaLibraries() -> Bool {
        var count: UInt32 = 0
        let libraries = _dyld_image_count()
        
        for i in 0..<libraries {
            if let name = _dyld_get_image_name(i) {
                let libraryName = String(cString: name)
                if libraryName.contains("FridaGadget") || 
                   libraryName.contains("frida") {
                    return true
                }
            }
        }
        return false
    }
}
```

#### 2. **Check for Frida Ports**

**Android:**
```kotlin
fun checkFridaPorts(): Boolean {
    val fridaPorts = listOf(27042, 27043)
    
    return try {
        val process = Runtime.getRuntime().exec("netstat -an")
        val reader = BufferedReader(process.inputStream.reader())
        val output = reader.readText()
        
        fridaPorts.any { output.contains(":$it") }
    } catch (e: Exception) {
        false
    }
}
```

**iOS:**
```swift
static func checkFridaPorts() -> Bool {
    let fridaPorts = [27042, 27043]
    
    let task = Process()
    task.launchPath = "/usr/sbin/netstat"
    task.arguments = ["-an"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    return fridaPorts.contains { port in
        output.contains(":\(port)")
    }
}
```

#### 3. **Check for Frida Files**

**Android:**
```kotlin
fun checkFridaFiles(): Boolean {
    val suspiciousPaths = listOf(
        "/data/local/tmp/frida-server",
        "/data/local/tmp/re.frida.server",
        "/sdcard/frida-server",
        "/system/bin/frida-server"
    )
    
    return suspiciousPaths.any { File(it).exists() }
}
```

**iOS:**
```swift
static func checkFridaFiles() -> Bool {
    let suspiciousPaths = [
        "/usr/lib/frida",
        "/Library/MobileSubstrate/DynamicLibraries/FridaGadget.dylib",
        "/var/lib/frida"
    ]
    
    return suspiciousPaths.contains { path in
        FileManager.default.fileExists(atPath: path)
    }
}
```

#### 4. **Timing-Based Detection**

**Android/iOS (Flutter Plugin):**
```dart
// Check execution time - Frida hooks add overhead
bool checkTimingAnomaly() {
  final start = DateTime.now().microsecondsSinceEpoch;
  
  // Perform simple operation
  for (int i = 0; i < 1000; i++) {
    i * 2;
  }
  
  final end = DateTime.now().microsecondsSinceEpoch;
  final duration = end - start;
  
  // If operation takes too long, might be hooked
  return duration > 1000; // Threshold in microseconds
}
```

---

## 🔓 Root Detection (Android)

### Detection Methods

#### 1. **Check for Root Binaries**

**MainActivity.kt:**
```kotlin
class RootChecker {
    companion object {
        fun isRooted(): Boolean {
            return checkRootBinaries() || 
                   checkRootPaths() || 
                   checkSuCommand() ||
                   checkRootPackages()
        }
        
        private fun checkRootBinaries(): Boolean {
            val rootBinaries = listOf(
                "/system/app/Superuser.apk",
                "/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/data/local/su",
                "/su/bin/su"
            )
            
            return rootBinaries.any { File(it).exists() }
        }
        
        private fun checkRootPaths(): Boolean {
            val rootPaths = listOf(
                "/data/local/",
                "/data/local/bin/",
                "/data/local/xbin/",
                "/sbin/",
                "/system/bin/",
                "/system/sbin/",
                "/system/xbin/",
                "/vendor/bin/"
            )
            
            return rootPaths.any { path ->
                try {
                    val file = File(path, "su")
                    file.exists() && file.canExecute()
                } catch (e: Exception) {
                    false
                }
            }
        }
        
        private fun checkSuCommand(): Boolean {
            return try {
                Runtime.getRuntime().exec("which su")
                    .waitFor() == 0
            } catch (e: Exception) {
                false
            }
        }
        
        private fun checkRootPackages(): Boolean {
            val rootPackages = listOf(
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
            )
            
            val packageManager = context.packageManager
            
            return rootPackages.any { packageName ->
                try {
                    packageManager.getPackageInfo(packageName, 0)
                    true
                } catch (e: PackageManager.NameNotFoundException) {
                    false
                }
            }
        }
    }
}
```

#### 2. **Check Build Tags**

**MainActivity.kt:**
```kotlin
fun checkBuildTags(): Boolean {
    val buildTags = android.os.Build.TAGS
    return buildTags != null && 
           (buildTags.contains("test-keys") || 
            buildTags.contains("dev-keys"))
}
```

#### 3. **Check for Dangerous Properties**

**MainActivity.kt:**
```kotlin
fun checkDangerousProperties(): Boolean {
    val dangerousProps = mapOf(
        "ro.debuggable" to "1",
        "ro.secure" to "0",
        "service.adb.root" to "1"
    )
    
    return dangerousProps.any { (key, value) ->
        try {
            val propValue = getSystemProperty(key)
            propValue == value
        } catch (e: Exception) {
            false
        }
    }
}

private fun getSystemProperty(key: String): String? {
    return try {
        val process = Runtime.getRuntime().exec("getprop $key")
        val reader = BufferedReader(process.inputStream.reader())
        reader.readLine()
    } catch (e: Exception) {
        null
    }
}
```

#### 4. **Check SELinux Status**

**MainActivity.kt:**
```kotlin
fun checkSELinux(): Boolean {
    return try {
        val process = Runtime.getRuntime().exec("getenforce")
        val reader = BufferedReader(process.inputStream.reader())
        val status = reader.readLine()?.lowercase()
        status == "permissive" || status == "disabled"
    } catch (e: Exception) {
        false
    }
}
```

---

## 🍎 Jailbreak Detection (iOS)

### Detection Methods

#### 1. **Check for Jailbreak Files**

**AppDelegate.swift:**
```swift
class JailbreakChecker {
    static func isJailbroken() -> Bool {
        return checkJailbreakFiles() ||
               checkJailbreakPaths() ||
               checkSuspiciousApps() ||
               checkSuspiciousLibraries() ||
               checkFork() ||
               checkSymbolicLinks()
    }
    
    static func checkJailbreakFiles() -> Bool {
        let jailbreakFiles = [
            "/Applications/Cydia.app",
            "/Applications/blackra1n.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/tmp/cydia.log",
            "/usr/bin/sshd",
            "/usr/libexec/ssh-keysign",
            "/var/cache/apt",
            "/var/lib/apt",
            "/var/lib/cydia",
            "/usr/sbin/frida-server",
            "/usr/bin/cycript",
            "/usr/local/bin/cycript",
            "/usr/lib/libcycript.dylib"
        ]
        
        return jailbreakFiles.contains { path in
            FileManager.default.fileExists(atPath: path)
        }
    }
    
    static func checkJailbreakPaths() -> Bool {
        let suspiciousPaths = [
            "/private/var/lib/apt",
            "/private/var/lib/dpkg",
            "/private/var/lib/cydia",
            "/Applications"
        ]
        
        return suspiciousPaths.contains { path in
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: path)
                // If we can read /Applications, might be jailbroken
                if path == "/Applications" && contents.count > 0 {
                    return true
                }
            } catch {
                // If we can't read, might be normal
            }
            return false
        }
    }
    
    static func checkSuspiciousApps() -> Bool {
        let suspiciousApps = [
            "Cydia",
            "blackra1n",
            "FakeCarrier",
            "Icy",
            "IntelliScreen",
            "MxTube",
            "RockApp",
            "SBSettings",
            "WinterBoard"
        ]
        
        return suspiciousApps.contains { app in
            UIApplication.shared.canOpenURL(URL(string: "\(app)://")!)
        }
    }
    
    static func checkSuspiciousLibraries() -> Bool {
        var count: UInt32 = 0
        let libraries = _dyld_image_count()
        
        for i in 0..<libraries {
            if let name = _dyld_get_image_name(i) {
                let libraryName = String(cString: name)
                if libraryName.contains("MobileSubstrate") ||
                   libraryName.contains("Substrate") ||
                   libraryName.contains("cycript") ||
                   libraryName.contains("libcycript") {
                    return true
                }
            }
        }
        return false
    }
    
    static func checkFork() -> Bool {
        let pid = fork()
        if pid >= 0 {
            if pid == 0 {
                exit(0)
            }
            return true // Fork succeeded, likely jailbroken
        }
        return false
    }
    
    static func checkSymbolicLinks() -> Bool {
        let suspiciousLinks = [
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]
        
        return suspiciousLinks.contains { path in
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: path)
                if let type = attributes[.type] as? FileAttributeType {
                    return type == .typeSymbolicLink
                }
            } catch {
                // Error reading attributes
            }
            return false
        }
    }
}
```

#### 2. **Check for Write Access**

**AppDelegate.swift:**
```swift
static func checkWriteAccess() -> Bool {
    let testPath = "/private/jailbreak_test.txt"
    
    do {
        try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
        try FileManager.default.removeItem(atPath: testPath)
        return true // Can write to root, likely jailbroken
    } catch {
        return false
    }
}
```

#### 3. **Check System Integrity Protection (SIP)**

**AppDelegate.swift:**
```swift
static func checkSIP() -> Bool {
    // On jailbroken devices, SIP might be disabled
    let task = Process()
    task.launchPath = "/usr/bin/csrutil"
    task.arguments = ["status"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    return output.contains("disabled")
}
```

---

## ✅ App Integrity Checks

### Android App Integrity

#### 1. **Check App Signature**

**MainActivity.kt:**
```kotlin
class AppIntegrityChecker {
    companion object {
        fun verifyAppSignature(context: Context): Boolean {
            return try {
                val packageInfo = context.packageManager
                    .getPackageInfo(
                        context.packageName,
                        PackageManager.GET_SIGNATURES
                    )
                
                val signatures = packageInfo.signatures
                val signature = signatures[0]
                val md = MessageDigest.getInstance("SHA-256")
                val hash = md.digest(signature.toByteArray())
                val hashString = hash.joinToString("") { "%02x".format(it) }
                
                // Compare with expected signature hash
                val expectedHash = "YOUR_EXPECTED_SIGNATURE_HASH"
                hashString == expectedHash
            } catch (e: Exception) {
                false
            }
        }
        
        fun checkAppInstaller(context: Context): Boolean {
            val installer = context.packageManager
                .getInstallerPackageName(context.packageName)
            
            // App should be installed from Play Store or official source
            return installer == "com.android.vending" || 
                   installer == "com.amazon.venezia" ||
                   installer == null // Allow null for direct installs
        }
        
        fun checkDebugMode(context: Context): Boolean {
            return try {
                val appInfo = context.applicationInfo
                (appInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
            } catch (e: Exception) {
                false
            }
        }
    }
}
```

#### 2. **Check APK Checksum**

**MainActivity.kt:**
```kotlin
fun verifyAPKChecksum(context: Context): Boolean {
    return try {
        val apkPath = context.packageCodePath
        val file = File(apkPath)
        val inputStream = FileInputStream(file)
        val md = MessageDigest.getInstance("SHA-256")
        val buffer = ByteArray(8192)
        var bytesRead: Int
        
        while (inputStream.read(buffer).also { bytesRead = it } != -1) {
            md.update(buffer, 0, bytesRead)
        }
        
        val hash = md.digest()
        val hashString = hash.joinToString("") { "%02x".format(it) }
        
        // Compare with expected checksum
        val expectedChecksum = "YOUR_EXPECTED_APK_CHECKSUM"
        hashString == expectedChecksum
    } catch (e: Exception) {
        false
    }
}
```

### iOS App Integrity

#### 1. **Check App Signature**

**AppDelegate.swift:**
```swift
class AppIntegrityChecker {
    static func verifyAppSignature() -> Bool {
        guard let bundlePath = Bundle.main.bundlePath else {
            return false
        }
        
        let task = Process()
        task.launchPath = "/usr/bin/codesign"
        task.arguments = ["-dv", bundlePath]
        
        let pipe = Pipe()
        task.standardError = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        // Check for valid signature
        return output.contains("Signature") && 
               !output.contains("not signed")
    }
    
    static func checkEntitlements() -> Bool {
        guard let bundlePath = Bundle.main.bundlePath else {
            return false
        }
        
        let task = Process()
        task.launchPath = "/usr/bin/codesign"
        task.arguments = ["-d", "--entitlements", ":-", bundlePath]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        // Check for suspicious entitlements
        let suspiciousEntitlements = [
            "com.apple.private.skip-library-validation",
            "com.apple.private.security.no-container"
        ]
        
        return !suspiciousEntitlements.contains { entitlement in
            output.contains(entitlement)
        }
    }
}
```

#### 2. **Check Bundle Integrity**

**AppDelegate.swift:**
```swift
static func checkBundleIntegrity() -> Bool {
    guard let bundlePath = Bundle.main.bundlePath else {
        return false
    }
    
    // Check if bundle is writable (shouldn't be)
    return !FileManager.default.isWritableFile(atPath: bundlePath)
}

static func verifyBundleChecksum() -> Bool {
    guard let bundlePath = Bundle.main.bundlePath else {
        return false
    }
    
    // Calculate SHA-256 of main executable
    guard let executablePath = Bundle.main.executablePath,
          let data = FileManager.default.contents(atPath: executablePath) else {
        return false
    }
    
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes { bytes in
        _ = CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
    }
    
    let hashString = hash.map { String(format: "%02x", $0) }.joined()
    
    // Compare with expected checksum
    let expectedChecksum = "YOUR_EXPECTED_EXECUTABLE_CHECKSUM"
    return hashString == expectedChecksum
}
```

---

## 🔐 Certificate Pinning

### Android Implementation

**NetworkSecurityConfig (res/xml/network_security_config.xml):**
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config>
        <domain includeSubdomains="true">api.example.com</domain>
        <pin-set expiration="2025-12-31">
            <!-- SHA-256 of your certificate -->
            <pin digest="SHA-256">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=</pin>
            <!-- Backup pin -->
            <pin digest="SHA-256">BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

**AndroidManifest.xml:**
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
</application>
```

### iOS Implementation

**AppDelegate.swift:**
```swift
import Security

class CertificatePinning {
    static func setupCertificatePinning() {
        // Implement in URLSession delegate
    }
}

// In URLSessionDelegate
func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
) {
    guard let serverTrust = challenge.protectionSpace.serverTrust else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
    }
    
    // Get certificate
    let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
    guard let certificateData = SecCertificateCopyData(certificate) else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
    }
    
    let data = CFDataGetBytePtr(certificateData)
    let size = CFDataGetLength(certificateData)
    let certificateBytes = Data(bytes: data!, count: size)
    
    // Calculate SHA-256
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    certificateBytes.withUnsafeBytes { bytes in
        _ = CC_SHA256(bytes.baseAddress, CC_LONG(certificateBytes.count), &hash)
    }
    
    let hashString = Data(hash).base64EncodedString()
    
    // Compare with pinned certificate
    let pinnedCertificate = "YOUR_PINNED_CERTIFICATE_HASH"
    if hashString == pinnedCertificate {
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    } else {
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
```

---

## 🎭 Code Obfuscation

### Android ProGuard Rules

**proguard-rules.pro:**
```proguard
# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Obfuscate everything else
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Obfuscate security classes (but keep functionality)
-keepclassmembers class com.example.security.** {
    *;
}
```

### Flutter Obfuscation

**Build Command:**
```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
flutter build ios --release --obfuscate --split-debug-info=./debug-info
```

---

## 🛡️ Anti-Tampering

### Android Implementation

**MainActivity.kt:**
```kotlin
class AntiTampering {
    companion object {
        fun checkAppTampering(context: Context): Boolean {
            return checkPackageName(context) &&
                   checkInstaller(context) &&
                   checkDebugFlag(context) &&
                   checkEmulator()
        }
        
        private fun checkPackageName(context: Context): Boolean {
            val expectedPackage = "com.example.yourapp"
            return context.packageName == expectedPackage
        }
        
        private fun checkEmulator(): Boolean {
            return (Build.FINGERPRINT.startsWith("generic") ||
                    Build.FINGERPRINT.startsWith("unknown") ||
                    Build.MODEL.contains("google_sdk") ||
                    Build.MODEL.contains("Emulator") ||
                    Build.MODEL.contains("Android SDK built for x86") ||
                    Build.MANUFACTURER.contains("Genymotion") ||
                    (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
                    "google_sdk" == Build.PRODUCT)
        }
    }
}
```

### iOS Implementation

**AppDelegate.swift:**
```swift
class AntiTampering {
    static func checkAppTampering() -> Bool {
        return checkBundleID() &&
               checkCodeSigning() &&
               !isRunningOnSimulator()
    }
    
    static func checkBundleID() -> Bool {
        let expectedBundleID = "com.example.yourapp"
        return Bundle.main.bundleIdentifier == expectedBundleID
    }
    
    static func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
```

---

## 💻 Implementation Examples

### Android MainActivity.kt

```kotlin
package com.example.yourapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/security"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Run security checks
        if (!performSecurityChecks()) {
            // Exit app if security checks fail
            finish()
            return
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isRooted" -> {
                        result.success(RootChecker.isRooted())
                    }
                    "isFridaRunning" -> {
                        result.success(SecurityChecker.isFridaRunning())
                    }
                    "checkAppIntegrity" -> {
                        result.success(AppIntegrityChecker.verifyAppSignature(this))
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }
    
    private fun performSecurityChecks(): Boolean {
        // Check for root
        if (RootChecker.isRooted()) {
            return false
        }
        
        // Check for Frida
        if (SecurityChecker.isFridaRunning()) {
            return false
        }
        
        // Check app integrity
        if (!AppIntegrityChecker.verifyAppSignature(this)) {
            return false
        }
        
        // Check for tampering
        if (AntiTampering.checkAppTampering(this)) {
            return false
        }
        
        return true
    }
}
```

### iOS AppDelegate.swift

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Run security checks
        if !performSecurityChecks() {
            // Exit app if security checks fail
            exit(0)
        }
        
        let controller = window?.rootViewController as! FlutterViewController
        let securityChannel = FlutterMethodChannel(
            name: "com.example.yourapp/security",
            binaryMessenger: controller.binaryMessenger
        )
        
        securityChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "isJailbroken":
                result(JailbreakChecker.isJailbroken())
            case "isFridaRunning":
                result(SecurityChecker.isFridaRunning())
            case "checkAppIntegrity":
                result(AppIntegrityChecker.verifyAppSignature())
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func performSecurityChecks() -> Bool {
        // Check for jailbreak
        if JailbreakChecker.isJailbroken() {
            return false
        }
        
        // Check for Frida
        if SecurityChecker.isFridaRunning() {
            return false
        }
        
        // Check app integrity
        if !AppIntegrityChecker.verifyAppSignature() {
            return false
        }
        
        // Check for tampering
        if AntiTampering.checkAppTampering() {
            return false
        }
        
        return true
    }
}
```

### Flutter Plugin Usage

**lib/core/security/security_service.dart:**
```dart
import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('com.example.yourapp/security');

  /// Check if device is rooted (Android) or jailbroken (iOS)
  static Future<bool> isDeviceCompromised() async {
    try {
      if (Platform.isAndroid) {
        return await _channel.invokeMethod<bool>('isRooted') ?? false;
      } else if (Platform.isIOS) {
        return await _channel.invokeMethod<bool>('isJailbroken') ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if Frida is running
  static Future<bool> isFridaRunning() async {
    try {
      return await _channel.invokeMethod<bool>('isFridaRunning') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check app integrity
  static Future<bool> checkAppIntegrity() async {
    try {
      return await _channel.invokeMethod<bool>('checkAppIntegrity') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Perform all security checks
  static Future<bool> performSecurityChecks() async {
    final isCompromised = await isDeviceCompromised();
    final isFrida = await isFridaRunning();
    final isIntegrityValid = await checkAppIntegrity();

    return !isCompromised && !isFrida && isIntegrityValid;
  }
}
```

**Usage in main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Perform security checks before app initialization
  final isSecure = await SecurityService.performSecurityChecks();
  
  if (!isSecure) {
    // Show error or exit
    exit(0);
  }
  
  runApp(MyApp());
}
```

---

## ✅ Best Practices

### 1. **Layered Security**

- ✅ Implement multiple detection methods
- ✅ Don't rely on a single check
- ✅ Combine static and dynamic checks

### 2. **Performance Considerations**

- ✅ Cache security check results
- ✅ Run checks asynchronously
- ✅ Don't block UI thread

### 3. **User Experience**

- ✅ Show user-friendly error messages
- ✅ Don't reveal why app is blocked
- ✅ Log security events for analysis

### 4. **Regular Updates**

- ✅ Update detection methods regularly
- ✅ Monitor new bypass techniques
- ✅ Keep dependencies updated

### 5. **Server-Side Validation**

- ✅ Validate device status on server
- ✅ Use device attestation APIs
- ✅ Implement rate limiting

### 6. **Code Protection**

- ✅ Obfuscate security-related code
- ✅ Use native code for critical checks
- ✅ Minimize security logic in Dart

### 7. **Testing**

- ✅ Test on rooted/jailbroken devices
- ✅ Test with Frida installed
- ✅ Test on emulators/simulators

### 8. **Monitoring**

- ✅ Log security events
- ✅ Track bypass attempts
- ✅ Analyze patterns

---

## 📦 Recommended Packages

### Flutter Packages

```yaml
dependencies:
  # Root/Jailbreak detection
  root_detector: ^1.0.0  # Community package
  
  # Certificate pinning
  http_certificate_pinning: ^2.0.0
  
  # Device info
  device_info_plus: ^9.1.0
```

### Native Libraries

**Android:**
- RootBeer (Root detection library)
- SafetyNet API (Google Play Services)

**iOS:**
- IOSSecuritySuite (Jailbreak detection)
- DeviceCheck API (Apple)

---

## 🚨 Important Notes

### Limitations

1. **No 100% Security**
   - Determined attackers can bypass checks
   - Security is about raising the bar, not perfect protection

2. **False Positives**
   - Some legitimate devices may trigger false positives
   - Balance security with user experience

3. **Performance Impact**
   - Security checks add overhead
   - Optimize for minimal impact

4. **Maintenance**
   - Security requires ongoing maintenance
   - New bypass methods emerge regularly

### Legal Considerations

- ✅ Inform users about security checks
- ✅ Comply with privacy regulations
- ✅ Don't collect unnecessary data

---

## 📚 Additional Resources

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Android Security Best Practices](https://developer.android.com/training/best-security)
- [iOS Security Guide](https://developer.apple.com/security/)
- [Frida Documentation](https://frida.re/docs/)

---

**Remember:** Security is a continuous process, not a one-time implementation. Regularly update your security measures and stay informed about new threats and bypass techniques.
