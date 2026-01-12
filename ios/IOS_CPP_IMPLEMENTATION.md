# iOS C++ Implementation Guide

## Overview

This guide explains how C++ code is implemented for iOS, matching the Android C++ implementation.

## Architecture

### Android (JNI)
- **C++ File**: `android/app/src/main/cpp/native-lib.cpp`
- **Bridge**: Kotlin `SecurityUtils.kt` uses JNI to call C++
- **Flutter**: Method channel calls Kotlin function

### iOS (Objective-C++)
- **C++ Files**: 
  - `ios/Runner/SecurityUtils.h` - C++ header
  - `ios/Runner/SecurityUtils.cpp` - C++ implementation
- **Bridge**: Objective-C++ `SecurityUtilsBridge.mm` bridges C++ to Swift
- **Flutter**: Method channel calls Swift function (which uses Objective-C++ bridge)

## File Structure

```
ios/Runner/
├── SecurityUtils.h              # C++ header
├── SecurityUtils.cpp            # C++ implementation
├── SecurityUtilsBridge.h        # Objective-C++ header
├── SecurityUtilsBridge.mm       # Objective-C++ bridge (bridges C++ to Swift)
├── Runner-Bridging-Header.h     # Swift bridging header (imports Objective-C++)
└── AppDelegate.swift            # Swift code (uses SecurityUtilsBridge)
```

## How It Works

1. **C++ Layer** (`SecurityUtils.cpp`):
   - Contains the actual C++ function `getSecretKey()`
   - Same implementation as Android

2. **Objective-C++ Bridge** (`SecurityUtilsBridge.mm`):
   - Objective-C++ file (`.mm` extension) can mix C++ and Objective-C
   - Calls the C++ function and converts to NSString
   - Exposes Objective-C class `SecurityUtilsBridge` with `getSecretKey()` method

3. **Swift Layer** (`AppDelegate.swift`):
   - Swift can call Objective-C classes through bridging header
   - Uses `SecurityUtilsBridge.getSecretKey()` to get the key
   - Returns to Flutter via method channel

## Key Differences: Android vs iOS

| Aspect | Android | iOS |
|--------|---------|-----|
| **C++ Bridge** | JNI (Java Native Interface) | Objective-C++ |
| **Native Language** | Kotlin/Java | Swift |
| **Bridge File** | `.kt` (Kotlin) | `.mm` (Objective-C++) |
| **Header** | JNI headers | C++ header + Objective-C++ header |
| **Method Call** | `SecurityUtils.getSecretKey()` | `SecurityUtilsBridge.getSecretKey()` |

## Benefits of Using C++ on Both Platforms

1. **Code Reusability**: Same C++ logic on both platforms
2. **Performance**: C++ is faster than interpreted languages
3. **Security**: Harder to reverse engineer than high-level code
4. **Consistency**: Same secret key generation logic on both platforms

## Testing

After setup, test that both platforms return the same key:

```dart
final key = await NativeSecurity.getSecretKey();
print('Secret key: $key');
// Should print: "my32lengthsupersecretnooneknows!!"
```

## Troubleshooting

### If C++ files don't compile:

1. Open project in Xcode: `open ios/Runner.xcworkspace`
2. Select the project → Build Settings
3. Search for "Compile Sources As"
4. Set to "Objective-C++" or "According to File Type"

### If bridging header errors:

1. Check `Runner-Bridging-Header.h` includes `SecurityUtilsBridge.h`
2. Verify bridging header path in Build Settings → "Objective-C Bridging Header"

### If Swift can't find SecurityUtilsBridge:

1. Ensure `SecurityUtilsBridge.h` is in the project
2. Check that `Runner-Bridging-Header.h` imports it
3. Clean build folder: Product → Clean Build Folder (Shift+Cmd+K)
