# 📋 Enum Guide

Complete guide for creating and managing enums in Flutter - when to use, where to place, and how to add new enums.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What are Enums?](#what-are-enums)
3. [When to Use Enums](#when-to-use-enums)
4. [Folder Structure](#folder-structure)
5. [Creating New Enums](#creating-new-enums)
6. [Enum Best Practices](#enum-best-practices)
7. [Examples](#examples)
8. [Common Patterns](#common-patterns)

---

## 📖 Overview

**Enums** (enumerations) are a way to define a set of named constants. They make code more readable, type-safe, and maintainable.

### Benefits
- ✅ Type-safe constants
- ✅ Better code readability
- ✅ Compile-time checking
- ✅ IDE autocomplete support
- ✅ Prevents typos and invalid values

---

## 🎯 What are Enums?

An enum is a special type that represents a fixed set of constant values.

### Basic Enum

```dart
enum Status {
  active,
  inactive,
  pending,
}
```

### Enhanced Enum (Dart 2.17+)

```dart
enum Status {
  active,
  inactive,
  pending;

  String get displayName {
    switch (this) {
      case Status.active:
        return 'Active';
      case Status.inactive:
        return 'Inactive';
      case Status.pending:
        return 'Pending';
    }
  }

  bool get isActive => this == Status.active;
}
```

---

## ✅ When to Use Enums

### ✅ Use Enums When:

1. **Fixed Set of Options**
   - Status values (loading, success, error)
   - User roles (admin, user, guest)
   - Order states (pending, processing, completed)

2. **State Management**
   - UI states (idle, loading, success, error)
   - App lifecycle states
   - Form validation states

3. **Configuration Options**
   - Theme modes (light, dark, system)
   - App flavors (development, staging, production)
   - Sort orders (ascending, descending)

4. **Type Safety Needed**
   - Replacing magic strings/numbers
   - Preventing invalid values
   - Better IDE support

### ❌ Don't Use Enums When:

1. **Dynamic Values**
   - User-generated content
   - API responses with unknown values
   - Values that change frequently

2. **Simple Constants**
   - Single values (use `const` instead)
   - Numeric constants (use `static const`)

3. **Feature-Specific Only**
   - If only used in one feature, place in feature folder

---

## 📁 Folder Structure

### Core Enums (Shared Across Features)

```
lib/core/enums/
├── state_status.dart          # StateStatus enum
├── upload_status.dart         # UploadStatus enum (example)
└── ENUM_GUIDE.md              # This guide
```

### Feature-Specific Enums

```
lib/features/[feature]/
└── domain/
    └── entities/
        └── [feature]_status.dart    # Feature-specific enum
```

### Constants Enums

```
lib/core/constants/
└── app_enums.dart             # App-wide enums (AppState, etc.)
```

### Flavor Enums

```
lib/core/flavor/
└── app_flavor.dart            # AppFlavor enum
```

---

## 🆕 Creating New Enums

### Step 1: Decide Location

**Core Enum** (used by multiple features):
- Location: `lib/core/enums/[enum_name].dart`
- Example: `StateStatus`, `UploadStatus`, `NetworkStatus`

**Feature Enum** (used by one feature):
- Location: `lib/features/[feature]/domain/entities/[enum_name].dart`
- Example: `OrderStatus` (only in orders feature)

**App-Wide Enum** (app configuration):
- Location: `lib/core/constants/app_enums.dart` or separate file
- Example: `AppState`, `ThemeMode`

### Step 2: Create Enum File

**For Core Enum:** `lib/core/enums/upload_status.dart`

```dart
/// Upload status enum
/// Used across features for file upload operations
enum UploadStatus {
  /// Initial state - not started
  idle,

  /// Upload in progress
  uploading,

  /// Upload completed successfully
  success,

  /// Upload failed
  failed,

  /// Upload was cancelled
  cancelled;

  /// Get human-readable name
  String get displayName {
    switch (this) {
      case UploadStatus.idle:
        return 'Idle';
      case UploadStatus.uploading:
        return 'Uploading';
      case UploadStatus.success:
        return 'Success';
      case UploadStatus.failed:
        return 'Failed';
      case UploadStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Check if upload is in progress
  bool get isUploading => this == UploadStatus.uploading;

  /// Check if upload is completed (success or failed)
  bool get isCompleted =>
      this == UploadStatus.success || this == UploadStatus.failed;

  /// Check if upload can be retried
  bool get canRetry => this == UploadStatus.failed || this == UploadStatus.cancelled;
}
```

### Step 3: Export Enum (If Needed)

**Option 1: Export in existing file**

Edit `lib/core/enums/state_status.dart`:

```dart
enum StateStatus {
  // ... existing values
}

// Add new enum in same file or separate file
enum UploadStatus {
  // ... enum definition
}
```

**Option 2: Create separate file and export**

Create `lib/core/enums/enums_export.dart`:

```dart
export 'state_status.dart';
export 'upload_status.dart';
```

### Step 4: Use Enum

```dart
import 'package:fluttersampleachitecture/core/enums/upload_status.dart';

class FileUploader {
  UploadStatus status = UploadStatus.idle;

  Future<void> upload() async {
    status = UploadStatus.uploading;
    
    try {
      // Upload logic
      status = UploadStatus.success;
    } catch (e) {
      status = UploadStatus.failed;
    }
  }

  void cancel() {
    if (status == UploadStatus.uploading) {
      status = UploadStatus.cancelled;
    }
  }
}
```

---

## ✅ Enum Best Practices

### 1. **Use Descriptive Names**

```dart
// ✅ Good
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

// ❌ Bad
enum OS {
  p,
  pr,
  s,
  d,
  c,
}
```

### 2. **Add Documentation**

```dart
/// Order status enum
/// Represents the current state of an order
enum OrderStatus {
  /// Order placed but not yet processed
  pending,

  /// Order is being prepared
  processing,

  /// Order has been shipped
  shipped,

  /// Order delivered to customer
  delivered,

  /// Order was cancelled
  cancelled;
}
```

### 3. **Add Helper Methods**

```dart
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  /// Check if order is active (not cancelled or delivered)
  bool get isActive =>
      this != OrderStatus.cancelled && this != OrderStatus.delivered;

  /// Get next possible status
  OrderStatus? get nextStatus {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.shipped;
      case OrderStatus.shipped:
        return OrderStatus.delivered;
      default:
        return null;
    }
  }
}
```

### 4. **Use Enhanced Enums for Complex Logic**

```dart
enum ThemeMode {
  light,
  dark,
  system;

  /// Get Material ThemeMode
  ThemeMode get materialThemeMode {
    switch (this) {
      case ThemeMode.light:
        return ThemeMode.light;
      case ThemeMode.dark:
        return ThemeMode.dark;
      case ThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if dark mode
  bool get isDark => this == ThemeMode.dark;
}
```

### 5. **Place in Correct Location**

- **Core enums** → `lib/core/enums/`
- **Feature enums** → `lib/features/[feature]/domain/entities/`
- **App config enums** → `lib/core/constants/` or `lib/core/flavor/`

### 6. **Use Enums Instead of Strings**

```dart
// ✅ Good
enum UserRole {
  admin,
  user,
  guest,
}

final role = UserRole.admin;

// ❌ Bad
final role = 'admin'; // Can have typos, no type safety
```

---

## 📚 Examples

### Example 1: State Status Enum

**File:** `lib/core/enums/state_status.dart`

```dart
enum StateStatus {
  idle,         // Default or initial state
  loading,      // Generic loading
  refreshing,   // Pull-to-refresh or background reload
  success,      // Operation succeeded
  error,        // Operation failed
  empty,        // No data available
  submitting,   // While sending a form or request
  updating,     // While editing or updating existing data
  deleting,     // While deleting an item
  noInternet,   // Network connection issue
  unauthorized, // Token expired or user not logged in
  paginating,   // Loading next page for infinite scroll
}
```

**Usage:**

```dart
class MyCubit extends Cubit<MyState> {
  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    
    try {
      final data = await repository.getData();
      emit(state.copyWith(
        status: StateStatus.success,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
        error: e.toString(),
      ));
    }
  }
}
```

### Example 2: App Flavor Enum

**File:** `lib/core/flavor/app_flavor.dart`

```dart
enum AppFlavor {
  development,
  staging,
  production;

  String get name {
    switch (this) {
      case AppFlavor.development:
        return 'Development';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.production:
        return 'Production';
    }
  }

  String get apiBaseUrl {
    switch (this) {
      case AppFlavor.development:
        return 'https://dev-api.example.com/api';
      case AppFlavor.staging:
        return 'https://staging-api.example.com/api';
      case AppFlavor.production:
        return 'https://api.example.com/api';
    }
  }
}
```

### Example 3: Feature-Specific Enum

**File:** `lib/features/orders/domain/entities/order_status.dart`

```dart
/// Order status enum
/// Specific to orders feature
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded;

  /// Get display name
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  /// Check if order is active
  bool get isActive =>
      this != OrderStatus.cancelled && this != OrderStatus.refunded;

  /// Check if order can be cancelled
  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.confirmed;
}
```

---

## 🔄 Common Patterns

### Pattern 1: Status Enum with Helpers

```dart
enum Status {
  idle,
  loading,
  success,
  error;

  bool get isLoading => this == Status.loading;
  bool get isSuccess => this == Status.success;
  bool get isError => this == Status.error;
  bool get isIdle => this == Status.idle;
}
```

### Pattern 2: Enum with Display Names

```dart
enum UserRole {
  admin,
  user,
  guest;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.user:
        return 'User';
      case UserRole.guest:
        return 'Guest';
    }
  }
}
```

### Pattern 3: Enum with Icons

```dart
enum NotificationType {
  info,
  success,
  warning,
  error;

  IconData get icon {
    switch (this) {
      case NotificationType.info:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
    }
  }
}
```

### Pattern 4: Enum with Colors

```dart
enum Priority {
  low,
  medium,
  high,
  urgent;

  Color get color {
    switch (this) {
      case Priority.low:
        return Colors.grey;
      case Priority.medium:
        return Colors.blue;
      case Priority.high:
        return Colors.orange;
      case Priority.urgent:
        return Colors.red;
    }
  }
}
```

### Pattern 5: Enum with Validation

```dart
enum AgeGroup {
  child,    // 0-12
  teen,     // 13-19
  adult,    // 20-64
  senior;   // 65+

  bool isValidAge(int age) {
    switch (this) {
      case AgeGroup.child:
        return age >= 0 && age <= 12;
      case AgeGroup.teen:
        return age >= 13 && age <= 19;
      case AgeGroup.adult:
        return age >= 20 && age <= 64;
      case AgeGroup.senior:
        return age >= 65;
    }
  }
}
```

---

## 📋 Quick Reference

### Enum Syntax

```dart
// Basic enum
enum EnumName {
  value1,
  value2,
  value3,
}

// Enhanced enum (with methods)
enum EnumName {
  value1,
  value2,
  value3;

  String get displayName {
    switch (this) {
      case EnumName.value1:
        return 'Value 1';
      // ...
    }
  }
}
```

### File Locations

| Type | Location | Example |
|------|----------|---------|
| **Core Enum** | `lib/core/enums/` | `state_status.dart` |
| **Feature Enum** | `lib/features/[feature]/domain/entities/` | `order_status.dart` |
| **App Enum** | `lib/core/constants/` | `app_enums.dart` |
| **Flavor Enum** | `lib/core/flavor/` | `app_flavor.dart` |

### When to Create New Enum

- ✅ Fixed set of related constants
- ✅ Used by multiple features (→ core/enums)
- ✅ Type safety needed
- ✅ Replacing magic strings/numbers

### When NOT to Create Enum

- ❌ Dynamic values
- ❌ Single constant (use `const` instead)
- ❌ Feature-specific only (→ feature folder)

---

## ✅ Checklist

When creating a new enum:

- [ ] Determine if it's core or feature-specific
- [ ] Choose correct location (`core/enums/` or feature folder)
- [ ] Use descriptive names
- [ ] Add documentation comments
- [ ] Add helper methods if needed (displayName, isX, etc.)
- [ ] Export if needed (for core enums)
- [ ] Use in code instead of strings/numbers

---

## 🎯 Summary

1. ✅ Use enums for fixed sets of related constants
2. ✅ Place core enums in `lib/core/enums/`
3. ✅ Place feature enums in feature folder
4. ✅ Add documentation and helper methods
5. ✅ Use enhanced enums for complex logic
6. ✅ Prefer enums over magic strings/numbers

---

**Need Help?** Check the [Dart Enum Documentation](https://dart.dev/language/enums)
