# 📦 Constants Guide

Complete guide for using constants in Flutter - when, why, and how to add and use them.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What are Constants?](#what-are-constants)
3. [Why Use Constants?](#why-use-constants)
4. [Constants Files](#constants-files)
5. [When to Use Each Type](#when-to-use-each-type)
6. [How to Add Constants](#how-to-add-constants)
7. [Usage Examples](#usage-examples)
8. [Best Practices](#best-practices)
9. [Common Patterns](#common-patterns)

---

## 📖 Overview

**Constants** are fixed values that don't change during app execution. They provide centralized, reusable values across the application.

### Benefits
- ✅ **Consistency** - Same values used everywhere
- ✅ **Maintainability** - Change once, update everywhere
- ✅ **Readability** - Descriptive names instead of magic numbers
- ✅ **Type Safety** - Compile-time checked
- ✅ **No Duplication** - Single source of truth

### File Structure

```
lib/core/constants/
├── app_enums.dart        # App-wide enums
├── app_strings.dart      # String constants
└── app_sizes.dart        # Size constants (padding, margins, etc.)
```

---

## 🎯 What are Constants?

**Constants** are values that:
- Don't change during runtime
- Are used in multiple places
- Should be centralized for consistency
- Have meaningful names

### Types of Constants

1. **Numeric Constants** - Numbers (timeouts, limits, sizes)
2. **String Constants** - Text values (labels, messages)
3. **Size Constants** - UI dimensions (padding, margins, text sizes)
4. **Enum Constants** - Fixed set of values (states, types)

---

## 💡 Why Use Constants?

### Problem Without Constants

**❌ Magic Numbers:**
```dart
// Hard to understand, hard to maintain
Container(
  padding: EdgeInsets.all(16.0),  // What is 16.0?
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 14.0),  // What is 14.0?
  ),
)

// Hardcoded strings
Text('Login')  // What if we need to change it?
Text('Invalid email or password')  // Duplicated everywhere?
```

**❌ Inconsistent Values:**
```dart
// Different values for same purpose
Container(padding: EdgeInsets.all(16.0))
Container(padding: EdgeInsets.all(15.0))  // Inconsistent!
Container(padding: EdgeInsets.all(18.0))  // Inconsistent!
```

### Solution With Constants

**✅ Descriptive Names:**
```dart
// Clear, descriptive, maintainable
Container(
  padding: EdgeInsets.all(AppSizes.paddingL),  // Clear: Large padding
  child: Text(
    AppStrings.login,  // Clear: Login text
    style: TextStyle(fontSize: AppSizes.textSizeM),  // Clear: Medium text
  ),
)
```

**✅ Consistent Values:**
```dart
// Same value everywhere
Container(padding: EdgeInsets.all(AppSizes.paddingL))
Container(padding: EdgeInsets.all(AppSizes.paddingL))  // Consistent!
Container(padding: EdgeInsets.all(AppSizes.paddingL))  // Consistent!
```

---

## 📦 Constants Files


```

### 1. `app_strings.dart` - String Constants

**Purpose:** Centralized string management for UI text

**Contains:**
- Button labels
- Error messages
- Success messages
- Validation messages
- Common UI text

**Example:**
```dart
class AppStrings {
  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';

  // Auth
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';

  // Errors
  static const String error = 'Error';
  static const String networkError = 'Network error. Please check your connection';
}
```

### 2. `app_sizes.dart` - Size Constants

**Purpose:** Centralized sizing for UI elements

**Contains:**
- Padding values
- Margin values
- Text sizes
- Icon sizes
- Border radius
- Button heights
- Elevation values

**Example:**
```dart
class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;

  // Text Sizes
  static const double textSizeXS = 10.0;
  static const double textSizeS = 12.0;
  static const double textSizeM = 14.0;
  static const double textSizeL = 16.0;

  // Icon Sizes
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
}
```

### 3. `app_enums.dart` - Enum Constants

**Purpose:** App-wide enums for state management and types

**Contains:**
- App lifecycle states
- Status enums
- Type enums

**Example:**
```dart
enum AppState {
  initializing,
  ready,
  background,
  foreground,
  terminating,
  error;
}
```

---

## ✅ When to Use Each Type

### Use `AppStrings` When:

- ✅ **UI Text** - Button labels, titles
- ✅ **Messages** - Error messages, success messages
- ✅ **Validation Messages** - Field validation text
- ✅ **Common Text** - OK, Cancel, Save, etc.

```dart
// ✅ Good - Use AppStrings
Text(AppStrings.login)
Text(AppStrings.invalidEmail)
ElevatedButton(child: Text(AppStrings.save))
```

### Use `AppSizes` When:

- ✅ **UI Dimensions** - Padding, margins, spacing
- ✅ **Text Sizing** - Font sizes
- ✅ **Icon Sizing** - Icon dimensions
- ✅ **Border Radius** - Corner radius
- ✅ **Component Heights** - Button, input heights

```dart
// ✅ Good - Use AppSizes
Container(
  padding: EdgeInsets.all(AppSizes.paddingL),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: AppSizes.textSizeM),
  ),
)
```

### Use `AppEnums` When:

- ✅ **Fixed Set of Values** - States, types, categories
- ✅ **Type Safety** - Compile-time checked values
- ✅ **State Management** - Status enums

```dart
// ✅ Good - Use AppEnums
enum StateStatus {
  idle,
  loading,
  success,
  error,
}
```

---

## 🔧 How to Add Constants

### Step 1: Choose the Right File

**Decision Tree:**
```
What type of constant?
├─ String/Text? → app_strings.dart
├─ Size/Dimension? → app_sizes.dart
└─ Enum? → app_enums.dart
```


**Adding to `app_strings.dart`:**
```dart
class AppStrings {
  // ... existing strings

  // Add new string constant
  static const String upload = 'Upload';
  static const String uploadSuccess = 'File uploaded successfully';
  static const String uploadFailed = 'Failed to upload file';
}
```

**Adding to `app_sizes.dart`:**
```dart
class AppSizes {
  // ... existing sizes

  // Add new size constant
  static const double paddingHuge = 40.0;
  static const double textSizeTiny = 8.0;
  static const double iconSizeTiny = 12.0;
}
```

### Step 3: Use Constant in Code

```dart
// Use the constant
Container(
  padding: EdgeInsets.all(AppSizes.paddingL),
  child: Text(
    AppStrings.upload,
    style: TextStyle(fontSize: AppSizes.textSizeM),
  ),
)
```

---

## 📚 Usage Examples

### Example 1: Using Size Constants

**Before (Magic Numbers):**
```dart
Container(
  padding: EdgeInsets.all(16.0),
  margin: EdgeInsets.all(8.0),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 14.0),
  ),
)
```

**After (Constants):**
```dart
Container(
  padding: EdgeInsets.all(AppSizes.paddingL),
  margin: EdgeInsets.all(AppSizes.marginS),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: AppSizes.textSizeM),
  ),
)
```

### Example 2: Using String Constants

**Before (Hardcoded Strings):**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Login'),
)

Text('Invalid email or password')
```

**After (Constants):**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(AppStrings.login),
)

Text(AppStrings.invalidCredentials)
```

### Example 3: Complete Widget Example

**Using All Constant Types:**
```dart
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Size constants
      padding: EdgeInsets.all(AppSizes.paddingL),
      margin: EdgeInsets.symmetric(horizontal: AppSizes.marginM),
      height: AppSizes.buttonHeightM,
      
      // String constants
      child: ElevatedButton(
        onPressed: () {
          // Validation with string constants
          if (password.length < 8) {
            showError(AppStrings.passwordTooShort);
          }
        },
        child: Text(
          AppStrings.login,  // String constant
          style: TextStyle(
            fontSize: AppSizes.textSizeM,  // Size constant
          ),
        ),
      ),
    );
  }
}
```

### Example 4: Using Constants in Validation

```dart
class EmailValidator {
  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return AppStrings.fieldRequired;  // String constant
    }
    
    if (email.length < 5 || email.length > 255) {
      return AppStrings.invalidEmail;  // String constant
    }
    
    if (!email.contains('@')) {
      return AppStrings.invalidEmail;  // String constant
    }
    
    return null;
  }
}
```

---

## ✅ Best Practices

### 1. **Use Constants, Not Magic Numbers**

```dart
// ✅ Good - Use constant
Container(
  padding: EdgeInsets.all(AppSizes.paddingL),
)

// ❌ Bad - Magic number
Container(
  padding: EdgeInsets.all(16.0),
)
```

### 2. **Use Descriptive Names**

```dart
// ✅ Good - Descriptive
static const double paddingL = 16.0;
static const String invalidEmail = 'Invalid email';

// ❌ Bad - Unclear
static const double p16 = 16.0;
static const String err1 = 'Invalid email';
```

### 3. **Group Related Constants**

```dart
// ✅ Good - Grouped
class AppStrings {
  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  
  // Auth
  static const String login = 'Login';
  static const String email = 'Email';
}
```

### 4. **Use Appropriate Types**

```dart
// ✅ Good - Correct type
static const Duration shortAnimation = Duration(milliseconds: 200);
static const int minPasswordLength = 8;
static const double paddingL = 16.0;

// ❌ Bad - Wrong type
static const int shortAnimation = 200;  // Should be Duration
static const String minPasswordLength = '8';  // Should be int
```

### 5. **Add Comments for Clarity**

```dart
// ✅ Good - Documented
// Common UI Text
static const String ok = 'OK';
static const String cancel = 'Cancel';

// Auth Labels
static const String login = 'Login';
static const String email = 'Email';
```

### 6. **Use Constants for Repeated Values**

```dart
// ✅ Good - Reusable constant
Text(AppStrings.login)  // Used in multiple places
Text(AppStrings.email)  // Used in multiple places

// ❌ Bad - Duplicated strings
Text('Login')  // Duplicated
Text('Email')  // Duplicated
```

### 7. **Don't Over-Constantize**

```dart
// ✅ Good - Constant for reusable value
static const double paddingL = 16.0;  // Used many times

// ❌ Bad - Constant for one-time use
static const double specificPadding = 17.5;  // Used once
// Just use 17.5 directly
```

---

## 🔄 Common Patterns

### Pattern 1: Consistent Spacing

```dart
// Use size constants for consistent spacing
Column(
  children: [
    Text('Item 1'),
    SizedBox(height: AppSizes.spacingM),
    Text('Item 2'),
    SizedBox(height: AppSizes.spacingM),
    Text('Item 3'),
  ],
)
```

### Pattern 2: Consistent Text Sizing

```dart
// Use size constants for consistent text
Text(
  'Title',
  style: TextStyle(fontSize: AppSizes.textSizeXL),
)
Text(
  'Subtitle',
  style: TextStyle(fontSize: AppSizes.textSizeM),
)
Text(
  'Body',
  style: TextStyle(fontSize: AppSizes.textSizeS),
)
```

### Pattern 3: Error Messages

```dart
// Use string constants for error messages
result.fold(
  (error) {
    if (error.contains('network')) {
      showError(AppStrings.networkError);
    } else if (error.contains('server')) {
      showError(AppStrings.serverError);
    } else {
      showError(AppStrings.unknownError);
    }
  },
  (data) => handleSuccess(data),
);
```

### Pattern 4: Validation Rules

```dart
// Use string constants for validation messages
class Validator {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (password.length < 8) {
      return '${AppStrings.minLength} 8 ${AppStrings.characters}';
    }
    
    return null;
  }
}
```

---

## 📋 Quick Reference

### Constants Files

| File | Purpose | Example |
|------|---------|---------|
| `app_strings.dart` | String constants | Labels, messages |
| `app_sizes.dart` | Size constants | Padding, text sizes |
| `app_enums.dart` | Enum constants | States, types |

### Common Constants

**AppStrings:**
- `login` - Login button text
- `email` - Email label
- `password` - Password label
- `error` - Error title
- `networkError` - Network error message

**AppSizes:**
- `paddingL` - Large padding (16.0)
- `textSizeM` - Medium text size (14.0)
- `iconSizeM` - Medium icon size (24.0)
- `radiusM` - Medium border radius (12.0)

### File Locations

- **Constants**: `lib/core/constants/`
- **AppStrings**: `lib/core/constants/app_strings.dart`
- **AppSizes**: `lib/core/constants/app_sizes.dart`
- **AppEnums**: `lib/core/constants/app_enums.dart`

---

## ✅ Checklist

When adding a new constant:

- [ ] Choose the right file (strings, sizes, enums)
- [ ] Use descriptive name
- [ ] Use appropriate type (int, String, double, Duration)
- [ ] Add comment if needed
- [ ] Group with related constants
- [ ] Use constant in code (don't duplicate)
- [ ] Update this guide if needed

---

## 🎯 Summary

1. ✅ **3 Constant Files** - AppStrings, AppSizes, AppEnums
2. ✅ **Use Constants** - Instead of magic numbers and hardcoded strings
3. ✅ **Descriptive Names** - Clear, meaningful constant names
4. ✅ **Consistent Values** - Same values used everywhere
5. ✅ **Maintainable** - Change once, update everywhere
6. ✅ **Type Safe** - Compile-time checked
7. ✅ **Best Practices** - Group related, document, use appropriately

---

**Why Constants?** They provide **consistency, maintainability, and readability** - essential for scalable Flutter applications!
