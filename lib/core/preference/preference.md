# Storage System Documentation

## Overview

The storage system provides a clean, type-safe interface for managing app preferences using SharedPreferences. It follows the abstract/implementation pattern for testability and flexibility.

## Architecture

```
app_pref_keys.dart    → All storage keys (versioned)
app_pref.dart         → Abstract interface
app_pref_impl.dart    → Concrete implementation (SharedPreferences)
```

## File Structure

### 1. `app_pref_keys.dart`
Contains all storage keys with versioning support.

**Key Features:**
- All keys are versioned using `prefVersion`
- Keys are grouped by category (Authentication, Theme, Localization, etc.)
- Never hardcode keys - always use `AppPrefKeys`

**Example:**
```dart
// Version key
static const String prefVersion = 'pref_version_1';

// All keys include version suffix
static const String token = 'auth_token$prefVersion';
// Results in: 'auth_tokenpref_version_1'
```

**Adding New Keys:**
```dart
// In app_pref_keys.dart
static const String myNewKey = 'my_new_key$prefVersion';
```

### 2. `app_pref.dart`
Abstract interface defining all storage operations.

**Key Features:**
- Abstract methods for all storage operations
- Type-safe with default values
- Easy to mock for testing

**Usage:**
```dart
// Get instance from dependency injection
final appPref = sl<AppPref>();

// Use methods
await appPref.setToken('my_token');
String token = appPref.getToken();
```

### 3. `app_pref_impl.dart`
Concrete implementation using SharedPreferences.

**Key Features:**
- Direct SharedPreferences integration
- Safe error handling with defaults
- Receives SharedPreferences instance via constructor (dependency injection)

## Initialization

### Setup in `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection (includes AppPref initialization)
  await initDependencyInjection();
  
  runApp(const FlutterSampleApp());
}
```

### Dependency Injection

Registered in `dependency_injection.dart`:

```dart
Future<void> _initCore() async {
  // Initialize SharedPreferences once
  final sharedPref = await SharedPreferences.getInstance();
  
  // Register AppPref as singleton with SharedPreferences instance
  sl.registerLazySingleton<AppPref>(() => AppPrefImpl(sharedPref));
}
```

**Benefits of this approach:**
- ✅ SharedPreferences initialized once and reused
- ✅ No separate `init()` call needed
- ✅ Clear dependency injection pattern
- ✅ Simpler initialization flow

## Usage Examples

### Authentication

```dart
final appPref = sl<AppPref>();

// Save token (automatically sets login status, last login time, session start)
await appPref.setToken('jwt_token_here');

// Get token
String token = appPref.getToken(); // Returns '' if not found

// Check if token exists
bool hasToken = appPref.hasToken();

// Save refresh token
await appPref.setRefreshToken('refresh_token');

// Save user ID
await appPref.setUserId('user123');

// Set login status
await appPref.setLoginStatus(true);

// Get login status
bool isLoggedIn = appPref.getLoginStatus(); // Returns false by default

// Check authentication
bool isAuth = appPref.isAuthenticated(); // Checks token + login status

// Check session validity
bool isValid = appPref.isSessionValid(timeoutMinutes: 43200); // 30 days default

// Logout (clears auth data, keeps userId and lastLoginTime)
await appPref.logout();

// Clear all auth data
await appPref.clearAuth();
```

### Theme Management

```dart
// Save theme mode
await appPref.setThemeMode('dark'); // 'light', 'dark', or 'system'

// Get theme mode
String theme = appPref.getThemeMode(); // Returns 'system' by default
```

### Localization

```dart
// Save locale
await appPref.setLocale('en');

// Get locale
String locale = appPref.getLocale(); // Returns 'en' by default
```

### Onboarding

```dart
// Set onboarding completed
await appPref.setOnboardingCompleted(true);

// Check onboarding status
bool completed = appPref.isOnboardingCompleted(); // Returns false by default
```

### Generic Storage Methods

```dart
// String
await appPref.setString('my_key', 'value');
String? value = appPref.getString('my_key');
String defaultValue = appPref.getStringOrDefault('my_key', 'default');

// Integer
await appPref.setInt('count', 42);
int? count = appPref.getInt('count');
int defaultCount = appPref.getIntOrDefault('count', 0);

// Boolean
await appPref.setBool('isEnabled', true);
bool? isEnabled = appPref.getBool('isEnabled');
bool defaultBool = appPref.getBoolOrDefault('isEnabled', false);

// Double
await appPref.setDouble('price', 99.99);
double? price = appPref.getDouble('price');
double defaultPrice = appPref.getDoubleOrDefault('price', 0.0);

// String List
await appPref.setStringList('tags', ['tag1', 'tag2']);
List<String>? tags = appPref.getStringList('tags');
List<String> defaultTags = appPref.getStringListOrDefault('tags', []);
```

### Utility Methods

```dart
// Remove a key
await appPref.remove('my_key');

// Clear all preferences
await appPref.clear(); // Use with caution!

// Check if key exists
bool exists = appPref.containsKey('my_key');

// Get all keys
Set<String> keys = appPref.getKeys();
```

## Versioning

### How It Works

All keys are automatically versioned using the `prefVersion` constant:

```dart
// In app_pref_keys.dart
static const String prefVersion = 'pref_version_1';

// All keys include version
static const String token = 'auth_token$prefVersion';
// Actual key: 'auth_tokenpref_version_1'
```

### Migration Strategy

When you need to reset or migrate preferences:

1. **Change the version** in `app_pref_keys.dart`:
   ```dart
   static const String prefVersion = 'pref_version_2';
   ```

2. **All keys automatically update**:
   - Old keys: `'auth_tokenpref_version_1'`
   - New keys: `'auth_tokenpref_version_2'`

3. **Old preferences remain** (not automatically deleted)
   - You can manually clear them if needed
   - Or implement migration logic in your app

### Example Migration

```dart
// Version 1
static const String prefVersion = 'pref_version_1';
// Keys: 'auth_tokenpref_version_1', 'user_idpref_version_1', etc.

// Version 2 (after update)
static const String prefVersion = 'pref_version_2';
// New keys: 'auth_tokenpref_version_2', 'user_idpref_version_2', etc.
// Old keys still exist but won't be used
```

## Best Practices

### 1. Always Use AppPrefKeys

✅ **Good:**
```dart
await appPref.setString(AppPrefKeys.token, 'value');
```

❌ **Bad:**
```dart
await appPref.setString('auth_token', 'value'); // Hardcoded key
```

### 2. Use Type-Safe Methods

✅ **Good:**
```dart
String token = appPref.getToken(); // Returns '' if not found
bool isLoggedIn = appPref.getLoginStatus(); // Returns false if not found
```

❌ **Bad:**
```dart
String? token = appPref.getString(AppPrefKeys.token); // Nullable, need null checks
```

### 3. Handle Errors Gracefully

All methods have built-in error handling and return safe defaults:

```dart
// These methods never throw exceptions
String token = appPref.getToken(); // Returns '' on error
bool status = appPref.getLoginStatus(); // Returns false on error
```

### 4. Use Dependency Injection

✅ **Good:**
```dart
class MyService {
  final AppPref _appPref;
  
  MyService(this._appPref);
  
  Future<void> saveData() async {
    await _appPref.setString('key', 'value');
  }
}
```

❌ **Bad:**
```dart
// Don't create instances directly
final appPref = AppPrefImpl(); // Wrong!
```

## Testing

### Mock Implementation

Create a mock for testing:

```dart
class MockAppPref implements AppPref {
  final Map<String, dynamic> _storage = {};
  
  @override
  Future<void> init() async {}
  
  @override
  String getToken() => _storage['token'] as String? ?? '';
  
  @override
  Future<bool> setToken(String token) async {
    _storage['token'] = token;
    return true;
  }
  
  // Implement other methods...
}
```

### Usage in Tests

```dart
void main() {
  setUp(() {
    sl.registerLazySingleton<AppPref>(() => MockAppPref());
  });
  
  test('should save token', () async {
    final appPref = sl<AppPref>();
    await appPref.setToken('test_token');
    expect(appPref.getToken(), 'test_token');
  });
}
```

## Security Considerations

### Current Implementation

- **Sensitive Data**: Tokens and user IDs are stored in plain text
- **Platform**: Uses SharedPreferences (not encrypted)

### Production Recommendations

1. **Encrypt Sensitive Data**:
   - Use `flutter_secure_storage` for tokens
   - Encrypt user IDs before storing

2. **Secure Storage**:
   ```dart
   // For sensitive data, use secure preference
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
   
   final secureStorage = FlutterSecureStorage();
   await secureStorage.write(key: 'token', value: token);
   ```

3. **Key Management**:
   - Never commit sensitive keys to version control
   - Use environment variables or secure key management

## Troubleshooting

### Common Issues

1. **"AppPref not initialized"**
   - Make sure `await initDependencyInjection()` is called in `main.dart`
   - SharedPreferences is initialized automatically in DI setup

2. **Keys not found**
   - Check that you're using `AppPrefKeys` constants
   - Verify version hasn't changed (old keys won't be found)

3. **Data not persisting**
   - Check SharedPreferences permissions
   - Verify `initDependencyInjection()` completed successfully

## Migration Guide

### Adding New Keys

1. Add key to `app_pref_keys.dart`:
   ```dart
   static const String myNewKey = 'my_new_key$prefVersion';
   ```

2. Add methods to `app_pref.dart` (abstract):
   ```dart
   Future<bool> setMyNewKey(String value);
   String getMyNewKey();
   ```

3. Implement in `app_pref_impl.dart`:
   ```dart
   @override
   Future<bool> setMyNewKey(String value) async {
     return await _instance.setString(AppPrefKeys.myNewKey, value);
   }
   
   @override
   String getMyNewKey() {
     return _getStringSafe(AppPrefKeys.myNewKey, '');
   }
   ```

## Summary

- ✅ **Clean Architecture**: Abstract interface + implementation
- ✅ **Type-Safe**: Methods with safe defaults
- ✅ **Versioned Keys**: Easy migration and reset
- ✅ **Error Handling**: Built-in safety with defaults
- ✅ **Testable**: Easy to mock for unit tests
- ✅ **Simple**: Direct SharedPreferences integration

For questions or issues, refer to the code comments or create an issue in the repository.
