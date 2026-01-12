# iOS C++ Setup Guide

This guide explains how to add C++ files to your iOS project for the same functionality as Android.

## Files Created

1. **SecurityUtils.h** - C++ header file
2. **SecurityUtils.cpp** - C++ implementation file
3. **SecurityUtilsBridge.h** - Objective-C++ header bridge
4. **SecurityUtilsBridge.mm** - Objective-C++ implementation bridge

## Steps to Add C++ Files to Xcode Project

### Method 1: Using Xcode (Recommended)

1. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. In Xcode, right-click on the `Runner` folder in the Project Navigator

3. Select **"Add Files to Runner..."**

4. Navigate to `ios/Runner/` and select:
   - `SecurityUtils.h`
   - `SecurityUtils.cpp`
   - `SecurityUtilsBridge.h`
   - `SecurityUtilsBridge.mm`

5. Make sure **"Copy items if needed"** is checked
6. Select **"Create groups"** (not "Create folder references")
7. Click **"Add"**

8. Verify the files are added:
   - Check that `.cpp` and `.mm` files are in the "Compile Sources" build phase
   - Check that `.h` files are in the "Headers" section

### Method 2: Manual Configuration (If needed)

If files don't compile automatically, you may need to:

1. Select the project in Xcode
2. Go to **Build Settings**
3. Search for **"Compile Sources As"**
4. Set it to **"Objective-C++"** or **"According to File Type"**

## Verification

After adding the files, the iOS app should use the same C++ implementation as Android:

- ✅ `SecurityUtils.cpp` contains the C++ function
- ✅ `SecurityUtilsBridge.mm` bridges C++ to Swift
- ✅ `AppDelegate.swift` uses `SecurityUtilsBridge.getSecretKey()`

## Testing

Run the app and verify that `NativeSecurity.getSecretKey()` works on iOS, returning the same key as Android.
