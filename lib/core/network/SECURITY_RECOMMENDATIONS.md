# 🔒 Security Recommendations

Security best practices for app URLs, environment variables, and code obfuscation in Flutter.

---

## 📋 Table of Contents

1. [URL Security](#url-security)
2. [Environment Variables Security](#environment-variables-security)
3. [Code Obfuscation](#code-obfuscation)
4. [API Key Protection](#api-key-protection)
5. [Best Practices](#best-practices)
6. [Implementation Checklist](#implementation-checklist)

---

## 🔐 URL Security

### Current Implementation

**Current:**
```dart
class AppUrls {
  static String get baseUrl => AppConfig.getBaseUrl();
  static String get login => '$baseUrl/login';
}
```

### Security Concerns

1. **Hardcoded URLs in Code** - Visible in decompiled APK/IPA
2. **No URL Validation** - No checks for malicious URLs
3. **No URL Encryption** - URLs stored in plain text
4. **Base URL Exposure** - Base URL visible in code

### Recommendations

#### 1. **Use Flutter Flavors with Environment Variables**

**Recommendation:**
- ✅ Use `--dart-define` for sensitive URLs
- ✅ Never commit URLs to version control
- ✅ Use `.env` files (gitignored) for local development

**Example:**
```dart
// Use environment variables
static String get baseUrl {
  const envUrl = String.fromEnvironment('API_BASE_URL');
  if (envUrl.isNotEmpty) {
    return envUrl;
  }
  // Fallback to flavor (less secure)
  return AppConfig.getBaseUrl();
}
```

**Build Command:**
```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

#### 2. **URL Validation**

**Recommendation:**
- ✅ Validate URLs before use
- ✅ Whitelist allowed domains
- ✅ Check URL scheme (https only in production)

**Example:**
```dart
static bool _isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    // Only allow HTTPS in production
    if (AppConfig.currentFlavor == AppFlavor.production) {
      return uri.scheme == 'https';
    }
    return uri.scheme == 'http' || uri.scheme == 'https';
  } catch (e) {
    return false;
  }
}

static String get baseUrl {
  final url = AppConfig.getBaseUrl();
  if (!_isValidUrl(url)) {
    throw Exception('Invalid base URL');
  }
  return url;
}
```

#### 3. **URL Obfuscation**

**Recommendation:**
- ✅ Use string obfuscation for sensitive URLs
- ✅ Split URLs into parts and reconstruct at runtime
- ✅ Use base64 encoding (not encryption, but obfuscation)

**Example:**
```dart
// Obfuscate URL parts
static String get baseUrl {
  // Split URL into parts
  final part1 = 'https://';
  final part2 = 'api';
  final part3 = '.example';
  final part4 = '.com';
  return '$part1$part2$part3$part4';
}

// Or use base64 (decode at runtime)
static String get baseUrl {
  const encoded = 'aHR0cHM6Ly9hcGkuZXhhbXBsZS5jb20='; // base64
  return utf8.decode(base64Decode(encoded));
}
```

#### 4. **Use Remote Config**

**Recommendation:**
- ✅ Fetch URLs from remote config service
- ✅ Update URLs without app update
- ✅ Centralized URL management

**Example:**
```dart
// Fetch from Firebase Remote Config or similar
static Future<String> get baseUrl async {
  final remoteConfig = await RemoteConfigService.getConfig();
  return remoteConfig.getString('api_base_url');
}
```

---

## 🔑 Environment Variables Security

### Current Implementation

**Current:**
```dart
const flavorString = String.fromEnvironment('APP_FLAVOR', defaultValue: 'development');
const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
```

### Security Concerns

1. **Visible in Build** - Environment variables visible in compiled code
2. **No Encryption** - Values stored in plain text
3. **Build Script Exposure** - CI/CD scripts may expose values
4. **No Validation** - No checks for valid values

### Recommendations

#### 1. **Use Secure Storage for Sensitive Values**

**Recommendation:**
- ✅ Store sensitive values in secure storage (Keychain/Keystore)
- ✅ Encrypt values before storage
- ✅ Use Flutter Secure Storage package

**Example:**
```dart
// Use flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureConfig {
  static const _storage = FlutterSecureStorage();
  
  static Future<String> getApiBaseUrl() async {
    // Try secure storage first
    final stored = await _storage.read(key: 'api_base_url');
    if (stored != null) return stored;
    
    // Fallback to environment variable
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      // Store in secure storage for future use
      await _storage.write(key: 'api_base_url', value: envUrl);
      return envUrl;
    }
    
    // Final fallback
    return AppConfig.getBaseUrl();
  }
}
```

#### 2. **Use .env Files (Gitignored)**

**Recommendation:**
- ✅ Use `flutter_dotenv` package
- ✅ Add `.env` to `.gitignore`
- ✅ Provide `.env.example` template

**Example:**
```dart
// .env file (gitignored)
API_BASE_URL=https://api.example.com
API_KEY=your-secret-key

// .env.example (committed)
API_BASE_URL=https://api.example.com
API_KEY=your-secret-key-here

// Usage
import 'package:flutter_dotenv/flutter_dotenv.dart';

static String get baseUrl {
  return dotenv.env['API_BASE_URL'] ?? AppConfig.getBaseUrl();
}
```

#### 3. **Encrypt Environment Variables**

**Recommendation:**
- ✅ Encrypt sensitive values before storing
- ✅ Use AES encryption with device-specific key
- ✅ Decrypt at runtime only

**Example:**
```dart
// Encrypt sensitive values
class SecureEnv {
  static String decryptApiUrl(String encrypted) {
    // Decrypt using device-specific key
    // Use crypto package or native encryption
    return decrypt(encrypted, deviceKey);
  }
  
  static String get baseUrl {
    const encrypted = String.fromEnvironment('ENCRYPTED_API_URL');
    if (encrypted.isNotEmpty) {
      return decryptApiUrl(encrypted);
    }
    return AppConfig.getBaseUrl();
  }
}
```

#### 4. **Use CI/CD Secrets Management**

**Recommendation:**
- ✅ Use GitHub Secrets, GitLab CI Variables, etc.
- ✅ Never hardcode secrets in build scripts
- ✅ Rotate secrets regularly

**Example (GitHub Actions):**
```yaml
# .github/workflows/build.yml
- name: Build APK
  run: |
    flutter build apk \
      --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }} \
      --dart-define=API_KEY=${{ secrets.API_KEY }}
```

---

## 🛡️ Code Obfuscation

### Current State

**Current:**
- No obfuscation enabled
- Code is readable in compiled app
- URLs and strings visible

### Recommendations

#### 1. **Enable Flutter Obfuscation**

**Recommendation:**
- ✅ Enable obfuscation for release builds
- ✅ Use `--obfuscate` flag
- ✅ Generate symbol file for crash reports

**Build Command:**
```bash
# Release build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# iOS
flutter build ios --release --obfuscate --split-debug-info=./debug-info
```

**pubspec.yaml:**
```yaml
flutter:
  # Enable obfuscation
  obfuscate: true
```

#### 2. **String Obfuscation**

**Recommendation:**
- ✅ Obfuscate sensitive strings
- ✅ Use string encryption
- ✅ Decrypt at runtime

**Example:**
```dart
// Obfuscate strings
class ObfuscatedStrings {
  // Encrypted/encoded strings
  static const _encodedLogin = 'bG9naW4='; // base64
  static const _encodedApi = 'YXBp'; // base64
  
  static String get login => utf8.decode(base64Decode(_encodedLogin));
  static String get api => utf8.decode(base64Decode(_encodedApi));
}
```

#### 3. **ProGuard/R8 Rules (Android)**

**Recommendation:**
- ✅ Use ProGuard rules to obfuscate code
- ✅ Remove unused code
- ✅ Obfuscate class/method names

**android/app/proguard-rules.pro:**
```proguard
# Obfuscate all code
-keepclassmembers class * {
    *;
}

# Keep only necessary classes
-keep class com.example.app.MainActivity
-keep class com.example.app.MainApplication
```

#### 4. **Strip Debug Symbols (iOS)**

**Recommendation:**
- ✅ Strip debug symbols in release
- ✅ Use bitcode (if needed)
- ✅ Remove unused code

**Xcode Build Settings:**
```
STRIP_STYLE = "all"
DEPLOYMENT_POSTPROCESSING = YES
```

---

## 🔐 API Key Protection

### Current State

**Current:**
- No API keys in code (good!)
- But if needed, would be visible

### Recommendations

#### 1. **Never Hardcode API Keys**

**❌ Bad:**
```dart
const apiKey = 'sk_live_1234567890'; // NEVER DO THIS
```

**✅ Good:**
```dart
// Use environment variables
const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
```

#### 2. **Use Secure Storage for API Keys**

**Recommendation:**
- ✅ Store API keys in secure storage
- ✅ Fetch from backend (not client)
- ✅ Use token-based authentication

**Example:**
```dart
// Fetch API key from secure backend
class ApiKeyManager {
  static Future<String> getApiKey() async {
    // Option 1: Fetch from your backend
    final response = await http.get('https://your-backend.com/api-key');
    return response.body;
    
    // Option 2: Use secure storage
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'api_key') ?? '';
  }
}
```

#### 3. **Use Backend Proxy**

**Recommendation:**
- ✅ Never expose API keys in client
- ✅ Use backend as proxy
- ✅ Client calls your backend, backend calls 3rd party

**Architecture:**
```
Client App → Your Backend → 3rd Party API
           (API Key here)
```

#### 4. **Key Rotation**

**Recommendation:**
- ✅ Rotate API keys regularly
- ✅ Use short-lived tokens
- ✅ Implement key revocation

---

## ✅ Best Practices

### 1. **URL Security Checklist**

- [ ] Use environment variables for URLs
- [ ] Validate URLs before use
- [ ] Use HTTPS only in production
- [ ] Whitelist allowed domains
- [ ] Obfuscate sensitive URLs
- [ ] Never commit URLs to git
- [ ] Use remote config for URL updates

### 2. **Environment Variables Checklist**

- [ ] Use `--dart-define` for sensitive values
- [ ] Store in secure storage when possible
- [ ] Encrypt sensitive values
- [ ] Use `.env` files (gitignored)
- [ ] Provide `.env.example` template
- [ ] Use CI/CD secrets management
- [ ] Rotate secrets regularly

### 3. **Code Obfuscation Checklist**

- [ ] Enable Flutter obfuscation for release
- [ ] Generate symbol files for crash reports
- [ ] Obfuscate sensitive strings
- [ ] Use ProGuard/R8 (Android)
- [ ] Strip debug symbols (iOS)
- [ ] Remove unused code

### 4. **API Key Protection Checklist**

- [ ] Never hardcode API keys
- [ ] Use backend proxy for 3rd party APIs
- [ ] Store keys in secure storage
- [ ] Fetch keys from backend
- [ ] Use token-based authentication
- [ ] Implement key rotation
- [ ] Use short-lived tokens

---

## 📦 Recommended Packages

### 1. **Environment Variables**

```yaml
dependencies:
  flutter_dotenv: ^5.1.0  # .env file support
```

### 2. **Secure Storage**

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0  # Secure keychain/keystore
```

### 3. **Encryption**

```yaml
dependencies:
  encrypt: ^5.0.1  # AES encryption
  crypto: ^3.0.3   # Cryptographic functions
```

### 4. **Remote Config**

```yaml
dependencies:
  firebase_remote_config: ^4.3.0  # Firebase Remote Config
  # OR
  remote_config: ^1.0.0  # Generic remote config
```

---

## 🎯 Implementation Priority

### High Priority (Must Have)

1. ✅ **Environment Variables** - Use `--dart-define` for URLs
2. ✅ **Code Obfuscation** - Enable for release builds
3. ✅ **URL Validation** - Validate URLs before use
4. ✅ **Secure Storage** - For API keys if needed

### Medium Priority (Should Have)

1. ✅ **URL Obfuscation** - Obfuscate sensitive URLs
2. ✅ **.env Files** - For local development
3. ✅ **CI/CD Secrets** - For build automation
4. ✅ **Backend Proxy** - For 3rd party API keys

### Low Priority (Nice to Have)

1. ✅ **Remote Config** - For dynamic URL updates
2. ✅ **Advanced Encryption** - For highly sensitive data
3. ✅ **Key Rotation** - For production apps

---

## 📝 Example Secure Implementation

### Secure AppUrls

```dart
class AppUrls {
  AppUrls._();

  // Get baseUrl from secure source
  static String get baseUrl {
    // Priority 1: Secure storage (if available)
    // Priority 2: Environment variable
    // Priority 3: Flavor config (least secure)
    
    final secureUrl = SecureConfig.getApiBaseUrl();
    if (secureUrl.isNotEmpty) return secureUrl;
    
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty && _isValidUrl(envUrl)) {
      return envUrl;
    }
    
    return AppConfig.getBaseUrl();
  }

  // Validate URL
  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      // HTTPS only in production
      if (AppConfig.currentFlavor == AppFlavor.production) {
        return uri.scheme == 'https';
      }
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  // Obfuscated endpoints
  static String get login => '$baseUrl/${_decode("bG9naW4=")}';
  
  static String _decode(String encoded) {
    return utf8.decode(base64Decode(encoded));
  }
}
```

### Secure Config Manager

```dart
class SecureConfig {
  static const _storage = FlutterSecureStorage();
  
  // Get API base URL securely
  static Future<String> getApiBaseUrl() async {
    // Try secure storage
    final stored = await _storage.read(key: 'api_base_url');
    if (stored != null) return stored;
    
    // Try environment variable
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      await _storage.write(key: 'api_base_url', value: envUrl);
      return envUrl;
    }
    
    // Fallback
    return AppConfig.getBaseUrl();
  }
  
  // Get API key securely
  static Future<String?> getApiKey() async {
    // Never store API key in client if possible
    // Fetch from backend instead
    return await _storage.read(key: 'api_key');
  }
}
```

---

## 🚨 Security Warnings

### ⚠️ Important Notes

1. **Client-Side Security is Limited**
   - Any code in client can be reverse-engineered
   - Obfuscation makes it harder, not impossible
   - Never store highly sensitive data in client

2. **Environment Variables are Visible**
   - `--dart-define` values are in compiled code
   - Can be extracted from APK/IPA
   - Use for non-critical values only

3. **Obfuscation is Not Encryption**
   - Obfuscation makes code harder to read
   - But determined attackers can still reverse-engineer
   - Use for code protection, not data protection

4. **Best Security: Backend Proxy**
   - Keep sensitive keys on backend
   - Client calls your backend
   - Backend calls 3rd party APIs
   - This is the most secure approach

---

## 📋 Summary

### For URLs:
- ✅ Use environment variables (`--dart-define`)
- ✅ Validate URLs before use
- ✅ Use HTTPS in production
- ✅ Obfuscate sensitive URLs
- ✅ Consider remote config

### For Environment Variables:
- ✅ Use secure storage when possible
- ✅ Encrypt sensitive values
- ✅ Use `.env` files (gitignored)
- ✅ Use CI/CD secrets management

### For Code Obfuscation:
- ✅ Enable Flutter obfuscation
- ✅ Use ProGuard/R8 (Android)
- ✅ Strip debug symbols (iOS)
- ✅ Obfuscate sensitive strings

### For API Keys:
- ✅ Never hardcode in client
- ✅ Use backend proxy
- ✅ Store in secure storage if needed
- ✅ Implement key rotation

---

**Remember:** Client-side security has limits. For maximum security, use a backend proxy for sensitive operations!
