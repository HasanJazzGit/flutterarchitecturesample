# 🔐 SharedPreferences Encryption Guide

Guide for using optional encryption in SharedPreferences.

---

## 📋 Overview

The app now supports **optional encryption** for SharedPreferences. Users can enable encryption to protect sensitive data like authentication tokens, user IDs, and other sensitive information.

---

## 🚀 Quick Start

### Enable Encryption Through AppPref

```dart
// After dependency injection is initialized
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI (encryption is optional and managed through AppPref)
  await initDependencyInjection();
  
  // Enable encryption through AppPref
  final appPref = sl<AppPref>();
  await appPref.initializeEncryption(
    key: 'Your32CharacterSecretKey!!', // 32 characters
    iv: '1234567890123456', // 16 characters
    enable: true,
  );
  
  runApp(const MyApp());
}
```

### Default Behavior (No Encryption)

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI - encryption is disabled by default
  await initDependencyInjection();
  
  runApp(const MyApp());
}
```

---

## 🔧 Configuration

### Encryption Key & IV

**Important:** For production, use strong, unique keys:

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

// After DI initialization
final appPref = sl<AppPref>();

// Initialize encryption with custom keys
await appPref.initializeEncryption(
  key: 'Your32CharacterSecretKey!!', // 32 characters for AES-256
  iv: '1234567890123456', // 16 characters for IV
  enable: true,
);
```

**Best Practices:**
- Use 32-character keys for AES-256
- Use 16-character IVs
- Store keys securely (not in code)
- Consider using device-specific keys
- Keys are stored in SharedPreferences (consider additional security for production)

---

## 💻 Usage

### Enable/Disable Encryption at Runtime

```dart
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';

// Get AppPref instance
final appPref = sl<AppPref>();

// Initialize encryption (first time setup)
await appPref.initializeEncryption(
  key: 'Your32CharacterSecretKey!!',
  iv: '1234567890123456',
  enable: true,
);

// Enable encryption
await appPref.setEncryptionEnabled(true);

// Disable encryption
await appPref.setEncryptionEnabled(false);

// Check if encryption is enabled
final isEnabled = appPref.isEncryptionEnabled();
print('Encryption enabled: $isEnabled');

// Update encryption key
await appPref.setEncryptionKey('New32CharacterSecretKey!!');

// Update encryption IV
await appPref.setEncryptionIV('New16CharIV12345');
```

### Save Encrypted Data

```dart
// All string values are automatically encrypted if encryption is enabled
await appPref.setToken('your_jwt_token'); // Encrypted
await appPref.setUserId('user123'); // Encrypted
await appPref.setString('sensitive_data', 'value'); // Encrypted
```

### Read Encrypted Data

```dart
// Data is automatically decrypted when reading
final token = appPref.getToken(); // Automatically decrypted
final userId = appPref.getUserId(); // Automatically decrypted
final data = appPref.getString('sensitive_data'); // Automatically decrypted
```

---

## 🔍 What Gets Encrypted?

### Encrypted (String Values)
- ✅ Authentication tokens
- ✅ Refresh tokens
- ✅ User IDs
- ✅ Theme mode
- ✅ Locale
- ✅ DateTime strings
- ✅ All custom string values
- ✅ String lists (each item encrypted)

### Not Encrypted (Non-String Values)
- ❌ Boolean values (stored as-is)
- ❌ Integer values (stored as-is)
- ❌ Double values (stored as-is)

**Note:** Non-string values are not encrypted because they don't contain sensitive text data. If you need to encrypt numbers, convert them to strings first.

---

## 📝 Examples

### Example 1: Enable Encryption on First Launch

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initDependencyInjection();
  
  // Check if user wants encryption (from settings, etc.)
  final appPref = sl<AppPref>();
  final userWantsEncryption = await getUserEncryptionPreference();
  
  if (userWantsEncryption) {
    await appPref.initializeEncryption(
      key: 'Your32CharacterSecretKey!!',
      iv: '1234567890123456',
      enable: true,
    );
  }
  
  runApp(const MyApp());
}
```

### Example 2: Toggle Encryption in Settings

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appPref = sl<AppPref>();
    final isEncrypted = appPref.isEncryptionEnabled();
    
    return SwitchListTile(
      title: Text('Enable Encryption'),
      value: isEncrypted,
      onChanged: (value) async {
        if (value && !isEncrypted) {
          // First time enabling - need to initialize
          await appPref.initializeEncryption(
            key: 'Your32CharacterSecretKey!!',
            iv: '1234567890123456',
            enable: true,
          );
        } else {
          // Toggle existing encryption
          await appPref.setEncryptionEnabled(value);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value 
                ? 'Encryption enabled' 
                : 'Encryption disabled'
            ),
          ),
        );
      },
    );
  }
}
```

### Example 3: Migrate Existing Data to Encrypted

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

Future<void> migrateToEncryption() async {
  final appPref = sl<AppPref>();
  
  // Initialize encryption
  await appPref.initializeEncryption(
    key: 'Your32CharacterSecretKey!!',
    iv: '1234567890123456',
    enable: true,
  );
  
  // Re-save existing data to encrypt it
  final token = appPref.getToken();
  if (token.isNotEmpty) {
    await appPref.setToken(token); // Will be encrypted
  }
  
  final userId = appPref.getUserId();
  if (userId.isNotEmpty) {
    await appPref.setUserId(userId); // Will be encrypted
  }
}
```

---

## ⚠️ Important Notes

### 1. Encryption is Optional
- Encryption is **disabled by default**
- Users must explicitly enable it
- Can be toggled on/off at runtime

### 2. Backward Compatibility
- Existing unencrypted data can be read
- When encryption is enabled, new data is encrypted
- Old unencrypted data remains unencrypted until re-saved

### 3. Performance
- Encryption/decryption adds minimal overhead
- Caching is used to avoid repeated checks
- Suitable for production use

### 4. Security Considerations
- **Default keys are not secure** - use custom keys in production
- Store encryption keys securely (not in code)
- Consider using device-specific keys
- Encryption protects data at rest, not in transit

---

## 🧪 Testing

### Test with Encryption Enabled

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initDependencyInjection();
  
  // Enable encryption
  final appPref = sl<AppPref>();
  await appPref.initializeEncryption(
    key: 'Your32CharacterSecretKey!!',
    iv: '1234567890123456',
    enable: true,
  );
  
  // Test encryption
  await appPref.setString('test', 'sensitive_data');
  final value = appPref.getString('test');
  assert(value == 'sensitive_data'); // Should decrypt correctly
}
```

### Test with Encryption Disabled

```dart
import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initDependencyInjection();
  
  // Test without encryption (default)
  final appPref = sl<AppPref>();
  await appPref.setString('test', 'data');
  final value = appPref.getString('test');
  assert(value == 'data'); // Should work normally
}
```

---

## 🔐 Security Best Practices

1. **Use Strong Keys**
   ```dart
   // Generate secure random keys
   final key = generateSecureKey(); // 32 chars
   final iv = generateSecureIV(); // 16 chars
   ```

2. **Store Keys Securely**
   - Don't hardcode keys in source code
   - Use secure storage (Keychain/Keystore)
   - Consider device-specific keys

3. **Enable for Sensitive Data**
   - Always encrypt authentication tokens
   - Encrypt user IDs and personal data
   - Consider encryption for all user data

4. **Handle Errors Gracefully**
   - Encryption failures fall back to plain text
   - Log errors for debugging
   - Don't expose encryption details to users

---

## 📚 API Reference

### AppPref Interface

```dart
abstract class AppPref {
  // Enable/disable encryption
  Future<bool> setEncryptionEnabled(bool enabled);
  
  // Check if encryption is enabled
  bool isEncryptionEnabled();
  
  // Set encryption key (32 characters)
  Future<bool> setEncryptionKey(String key);
  
  // Set encryption IV (16 characters)
  Future<bool> setEncryptionIV(String iv);
  
  // Initialize encryption with key and IV
  Future<bool> initializeEncryption({
    required String key,
    required String iv,
    bool enable = true,
  });
  
  // All other AppPref methods work the same way
  // Encryption is handled automatically when enabled
}
```

### EncryptionService

```dart
class EncryptionService {
  // Encrypt a string
  String encrypt(String plainText);
  
  // Decrypt a string
  String decrypt(String encryptedText);
  
  // Check if string is encrypted
  bool isEncrypted(String value);
}
```

---

## 🐛 Troubleshooting

### Issue: Data not encrypting

**Solution:** Check if encryption is enabled:
```dart
if (appPref is AppPrefEncryptedImpl) {
  print('Encryption enabled: ${appPref.isEncryptionEnabled()}');
}
```

### Issue: Decryption errors

**Solution:** Data might be unencrypted. The service handles this automatically by returning the original value.

### Issue: Performance concerns

**Solution:** Encryption overhead is minimal. If needed, only encrypt sensitive keys, not all data.

---

## ✅ Summary

- ✅ Encryption is **optional** - users can enable/disable through AppPref
- ✅ Works with existing `AppPref` interface
- ✅ Automatically encrypts/decrypts string values
- ✅ Can be configured and toggled at runtime
- ✅ Keys and IV can be set through AppPref methods
- ✅ Backward compatible with existing data
- ✅ Production-ready with proper key management
- ✅ No need to configure encryption at app startup

**Next Steps:**
1. Use `AppPref.initializeEncryption()` to set up encryption when needed
2. Use custom encryption keys for production
3. Test encryption with your data
4. Consider user preference for encryption
5. Store encryption keys securely (consider additional security layers for production)
