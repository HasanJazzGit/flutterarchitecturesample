# 🎨 Theme Guide

Complete guide for using themes in Flutter - Material 3, custom colors, light/dark themes, and theme switching.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What is a Theme?](#what-is-a-theme)
3. [Theme Files](#theme-files)
4. [AppTheme - Theme Configuration](#apptheme---theme-configuration)
5. [AppColors - Custom Colors](#appcolors---custom-colors)
6. [Using Themes](#using-themes)
7. [Adding New Colors](#adding-new-colors)
8. [Theme Switching](#theme-switching)
9. [Best Practices](#best-practices)
10. [Common Patterns](#common-patterns)

---

## 📖 Overview

**Themes** define the visual appearance of your app - colors, typography, component styles, and more. This project uses Material 3 design system with custom color extensions.

### Benefits
- ✅ **Consistent Design** - Unified look across the app
- ✅ **Material 3** - Modern Material Design
- ✅ **Dark Mode** - Built-in dark theme support
- ✅ **Custom Colors** - Extended color palette
- ✅ **Type Safety** - Compile-time checked colors
- ✅ **Easy Theming** - Centralized theme management

### File Structure

```
lib/core/theme/
├── app_theme.dart    # Theme configuration (light/dark)
└── app_colors.dart   # Custom color extensions
```

---

## 🎯 What is a Theme?

**Theme** defines:
- **Colors** - Primary, secondary, surface, background, etc.
- **Typography** - Text styles, font sizes, weights
- **Component Styles** - Buttons, cards, inputs, etc.
- **Shapes** - Border radius, elevation, etc.

### Theme Modes

Flutter supports three theme modes:
- **Light** - Light color scheme
- **Dark** - Dark color scheme
- **System** - Follows device setting

---

## 📦 Theme Files

### 1. `app_theme.dart` - Theme Configuration

**Purpose:** Defines light and dark theme configurations

**Contains:**
- Light theme (`AppTheme.lightTheme`)
- Dark theme (`AppTheme.darkTheme`)
- Material 3 configuration
- Component themes (buttons, cards, inputs)
- Typography (text styles)

**Example:**
```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.light.primary,
        brightness: Brightness.light,
      ),
      // ... component themes
    );
  }

  static ThemeData get darkTheme {
    // ... dark theme configuration
  }
}
```

### 2. `app_colors.dart` - Custom Color Extensions

**Purpose:** Custom color palette extending Material 3

**Contains:**
- Material 3 colors (primary, secondary, error, etc.)
- Custom colors (success, warning, info, etc.)
- Light theme colors (`AppColors.light`)
- Dark theme colors (`AppColors.dark`)
- ThemeExtension implementation

**Example:**
```dart
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color? success;
  final Color? warning;
  // ... more colors

  static const AppColors light = AppColors(
    primary: Color(0xFF6750A4),
    success: Color(0xFF4CAF50),
    // ... light colors
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFFD0BCFF),
    success: Color(0xFF66BB6A),
    // ... dark colors
  );
}
```

---

## 🎨 AppTheme - Theme Configuration

### Light Theme

```dart
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,  // Material 3 enabled
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.light.primary,
      brightness: Brightness.light,
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppColors.light,  // Custom colors
    ],
    scaffoldBackgroundColor: AppColors.light.background,
    // Component themes
    appBarTheme: AppBarTheme(...),
    cardTheme: CardThemeData(...),
    elevatedButtonTheme: ElevatedButtonThemeData(...),
    inputDecorationTheme: InputDecorationTheme(...),
    textTheme: TextTheme(...),  // Typography
  );
}
```

### Dark Theme

```dart
static ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.dark.primary,
      brightness: Brightness.dark,
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppColors.dark,  // Custom colors
    ],
    // ... same structure as light theme
  );
}
```

### Component Themes

**AppBar Theme:**
```dart
appBarTheme: AppBarTheme(
  centerTitle: true,
  elevation: 0,
  backgroundColor: AppColors.light.surface,
  foregroundColor: AppColors.light.onSurface,
),
```

**Card Theme:**
```dart
cardTheme: CardThemeData(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
),
```

**Button Theme:**
```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
```

**Input Theme:**
```dart
inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  filled: true,
  fillColor: AppColors.light.surface,
),
```

---

## 🎨 AppColors - Custom Colors

### Material 3 Colors

**Required Colors:**
- `primary` - Primary brand color
- `secondary` - Secondary brand color
- `tertiary` - Tertiary brand color
- `error` - Error color
- `surface` - Surface color
- `background` - Background color
- `onPrimary` - Text on primary
- `onSecondary` - Text on secondary
- `onTertiary` - Text on tertiary
- `onError` - Text on error
- `onSurface` - Text on surface
- `onBackground` - Text on background

### Custom Colors

**Status Colors:**
- `success` - Success state (green)
- `warning` - Warning state (orange)
- `info` - Info state (blue)

**UI Colors:**
- `divider` - Divider color
- `border` - Border color
- `shadow` - Shadow color
- `disabled` - Disabled state color
- `hint` - Hint text color

**Text Colors:**
- `textPrimary` - Primary text
- `textSecondary` - Secondary text
- `textTertiary` - Tertiary text

**Icon Colors:**
- `iconColor` - Primary icon color
- `iconSecondary` - Secondary icon color

**Brand Colors:**
- `brandPrimary` - Brand primary
- `brandSecondary` - Brand secondary
- `brandAccent` - Brand accent

**Semantic Colors:**
- `link` - Link color
- `visited` - Visited link color
- `highlight` - Highlight color
- `selected` - Selected state color

**Background Colors:**
- `backgroundPrimary` - Primary background
- `backgroundSecondary` - Secondary background
- `backgroundTertiary` - Tertiary background

**Overlay Colors:**
- `overlay` - Overlay color
- `overlayDark` - Dark overlay color

### Light Theme Colors

```dart
static const AppColors light = AppColors(
  // Material 3 colors
  primary: Color(0xFF6750A4),
  secondary: Color(0xFF625B71),
  error: Color(0xFFBA1A1A),
  surface: Color(0xFFFFFBFE),
  background: Color(0xFFFFFBFE),
  
  // Custom colors
  success: Color(0xFF4CAF50),
  warning: Color(0xFFFF9800),
  info: Color(0xFF2196F3),
  // ... more colors
);
```

### Dark Theme Colors

```dart
static const AppColors dark = AppColors(
  // Material 3 colors
  primary: Color(0xFFD0BCFF),
  secondary: Color(0xFFCCC2DC),
  error: Color(0xFFFFB4AB),
  surface: Color(0xFF1C1B1F),
  background: Color(0xFF1C1B1F),
  
  // Custom colors
  success: Color(0xFF66BB6A),
  warning: Color(0xFFFFA726),
  info: Color(0xFF42A5F5),
  // ... more colors
);
```

---

## 🔧 Using Themes

### 1. Apply Theme in MaterialApp

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // or light, dark
  // ... other config
)
```

### 2. Access Theme in Widgets

**Using Theme.of(context):**
```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return Container(
    color: colorScheme.primary,
    child: Text(
      'Hello',
      style: theme.textTheme.headlineLarge,
    ),
  );
}
```

**Using ColorScheme:**
```dart
final colorScheme = Theme.of(context).colorScheme;

// Material 3 colors
colorScheme.primary
colorScheme.secondary
colorScheme.error
colorScheme.surface
colorScheme.background
```

**Using Custom Colors (AppColors):**
```dart
final appColors = Theme.of(context).extension<AppColors>();

// Custom colors
appColors?.success
appColors?.warning
appColors?.textPrimary
```

### 3. Using Text Styles

```dart
final textTheme = Theme.of(context).textTheme;

// Material 3 text styles
Text('Title', style: textTheme.headlineLarge)
Text('Subtitle', style: textTheme.titleMedium)
Text('Body', style: textTheme.bodyMedium)
Text('Label', style: textTheme.labelSmall)
```

### 4. Complete Example

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColors>();
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'My App',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Success',
              style: TextStyle(
                color: appColors?.success,
                fontSize: 24,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ➕ Adding New Colors

### Step 1: Add Color to AppColors Class

```dart
class AppColors extends ThemeExtension<AppColors> {
  // ... existing colors
  
  // Add new color
  final Color? myCustomColor;
  
  const AppColors({
    // ... existing parameters
    this.myCustomColor,  // Add to constructor
  });
}
```

### Step 2: Add to Light Theme

```dart
static const AppColors light = AppColors(
  // ... existing colors
  myCustomColor: Color(0xFF123456),  // Light theme color
);
```

### Step 3: Add to Dark Theme

```dart
static const AppColors dark = AppColors(
  // ... existing colors
  myCustomColor: Color(0xFF654321),  // Dark theme color
);
```

### Step 4: Update copyWith Method

```dart
@override
AppColors copyWith({
  // ... existing parameters
  Color? myCustomColor,  // Add parameter
}) {
  return AppColors(
    // ... existing assignments
    myCustomColor: myCustomColor ?? this.myCustomColor,
  );
}
```

### Step 5: Update lerp Method

```dart
@override
AppColors lerp(ThemeExtension<AppColors>? other, double t) {
  if (other is! AppColors) {
    return this;
  }
  return AppColors(
    // ... existing lerp calls
    myCustomColor: Color.lerp(myCustomColor, other.myCustomColor, t),
  );
}
```

### Step 6: Use New Color

```dart
final appColors = Theme.of(context).extension<AppColors>();

Container(
  color: appColors?.myCustomColor,
)
```

---

## 🔄 Theme Switching

### 1. Theme State Management

**AppState:**
```dart
class AppState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppState({
    required this.themeMode,
    required this.locale,
  });
}
```

**AppCubit:**
```dart
class AppCubit extends Cubit<AppState> {
  /// Change app theme mode
  Future<void> changeTheme(ThemeMode themeMode) async {
    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await _appPref.setThemeMode(themeModeString);
    emit(state.copyWith(themeMode: themeMode));
  }
}
```

### 2. Apply Theme in MaterialApp

```dart
BlocBuilder<AppCubit, AppState>(
  builder: (context, state) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: state.themeMode,  // From state
      // ... other config
    );
  },
)
```

### 3. Theme Switcher UI

```dart
class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appCubit = context.read<AppCubit>();
    final currentTheme = context.select((AppCubit cubit) => cubit.state.themeMode);
    
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.light, label: Text('Light')),
        ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
        ButtonSegment(value: ThemeMode.system, label: Text('System')),
      ],
      selected: {currentTheme},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        appCubit.changeTheme(newSelection.first);
      },
    );
  }
}
```

### 4. Theme Bottom Sheet Example

```dart
void showThemeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: context.read<AppCubit>(),
        child: ThemeBottomSheet(),
      );
    },
  );
}
```

---

## ✅ Best Practices

### 1. **Use ColorScheme for Material Colors**

```dart
// ✅ Good - Use ColorScheme
final colorScheme = Theme.of(context).colorScheme;
Container(color: colorScheme.primary)

// ❌ Bad - Hardcoded color
Container(color: Color(0xFF6750A4))
```

### 2. **Use AppColors for Custom Colors**

```dart
// ✅ Good - Use AppColors extension
final appColors = Theme.of(context).extension<AppColors>();
Container(color: appColors?.success)

// ❌ Bad - Hardcoded custom color
Container(color: Color(0xFF4CAF50))
```

### 3. **Use TextTheme for Typography**

```dart
// ✅ Good - Use TextTheme
Text('Title', style: theme.textTheme.headlineLarge)

// ❌ Bad - Hardcoded text style
Text('Title', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400))
```

### 4. **Always Provide Light and Dark Colors**

```dart
// ✅ Good - Both themes
static const AppColors light = AppColors(
  myColor: Color(0xFF123456),  // Light
);

static const AppColors dark = AppColors(
  myColor: Color(0xFF654321),  // Dark
);

// ❌ Bad - Only light theme
static const AppColors light = AppColors(
  myColor: Color(0xFF123456),
);
// Missing dark theme!
```

### 5. **Use ThemeMode.system as Default**

```dart
// ✅ Good - System default
factory AppState.initial() {
  return const AppState(
    themeMode: ThemeMode.system,
    locale: Locale('en'),
  );
}

// ❌ Bad - Hardcoded light
factory AppState.initial() {
  return const AppState(
    themeMode: ThemeMode.light,  // Doesn't respect system
    locale: Locale('en'),
  );
}
```

### 6. **Save Theme Preference**

```dart
// ✅ Good - Persist theme
Future<void> changeTheme(ThemeMode themeMode) async {
  await _appPref.setThemeMode(themeModeString);
  emit(state.copyWith(themeMode: themeMode));
}

// ❌ Bad - Don't persist
Future<void> changeTheme(ThemeMode themeMode) async {
  emit(state.copyWith(themeMode: themeMode));  // Lost on restart
}
```

### 7. **Use Null-Safe Access for Custom Colors**

```dart
// ✅ Good - Null-safe
final appColors = Theme.of(context).extension<AppColors>();
Container(color: appColors?.success ?? Colors.green)

// ❌ Bad - Force unwrap
final appColors = Theme.of(context).extension<AppColors>()!;
Container(color: appColors.success)  // Might crash
```

---

## 🔄 Common Patterns

### Pattern 1: Themed Container

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Content',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

### Pattern 2: Themed Card

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'Subtitle',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  ),
)
```

### Pattern 3: Status Colors

```dart
final appColors = Theme.of(context).extension<AppColors>();

Container(
  color: appColors?.success,  // Success state
  child: Text('Success'),
)

Container(
  color: appColors?.warning,  // Warning state
  child: Text('Warning'),
)

Container(
  color: appColors?.error,  // Error state
  child: Text('Error'),
)
```

### Pattern 4: Themed Button

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  child: Text('Button'),
)
```

### Pattern 5: Themed Input Field

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    // Uses inputDecorationTheme from AppTheme
  ),
)
```

---

## 📋 Quick Reference

### Theme Access

| Method | Purpose | Example |
|--------|---------|---------|
| `Theme.of(context)` | Get theme | `Theme.of(context).colorScheme` |
| `theme.colorScheme` | Material 3 colors | `colorScheme.primary` |
| `theme.extension<AppColors>()` | Custom colors | `appColors?.success` |
| `theme.textTheme` | Typography | `textTheme.headlineLarge` |

### Material 3 Colors

| Color | Purpose |
|-------|---------|
| `primary` | Primary brand color |
| `secondary` | Secondary brand color |
| `error` | Error color |
| `surface` | Surface color |
| `background` | Background color |
| `onPrimary` | Text on primary |
| `onSurface` | Text on surface |

### Custom Colors (AppColors)

| Color | Purpose |
|-------|---------|
| `success` | Success state |
| `warning` | Warning state |
| `info` | Info state |
| `textPrimary` | Primary text |
| `textSecondary` | Secondary text |
| `iconColor` | Icon color |

### File Locations

- **Theme Config**: `lib/core/theme/app_theme.dart`
- **Custom Colors**: `lib/core/theme/app_colors.dart`

---

## ✅ Checklist

When working with themes:

- [ ] Use `ColorScheme` for Material 3 colors
- [ ] Use `AppColors` extension for custom colors
- [ ] Use `TextTheme` for typography
- [ ] Provide both light and dark colors
- [ ] Save theme preference
- [ ] Use null-safe access for custom colors
- [ ] Test both light and dark themes

---

## 🎯 Summary

1. ✅ **Material 3** - Modern Material Design system
2. ✅ **Light/Dark Themes** - Built-in theme support
3. ✅ **Custom Colors** - Extended color palette via ThemeExtension
4. ✅ **Theme Switching** - Dynamic theme changes with state management
5. ✅ **Type Safety** - Compile-time checked colors
6. ✅ **Best Practices** - Use ColorScheme, AppColors, TextTheme
7. ✅ **Persistent** - Theme preference saved and restored

---

**Why Themes?** They provide **consistent, maintainable design** with **Material 3** and **dark mode support** - essential for modern Flutter applications!
