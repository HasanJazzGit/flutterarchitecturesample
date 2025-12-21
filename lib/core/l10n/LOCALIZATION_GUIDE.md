# 🌍 Localization Guide

Complete guide for implementing and managing localization (i18n) in this Flutter project.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [File Structure](#file-structure)
3. [How It Works](#how-it-works)
4. [Adding New Translations](#adding-new-translations)
5. [Using Translations in Code](#using-translations-in-code)
6. [Adding a New Language](#adding-a-new-language)
7. [Changing Language at Runtime](#changing-language-at-runtime)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## 📖 Overview

**Localization (i18n)** allows your app to support multiple languages. This project uses Flutter's built-in localization system with ARB (Application Resource Bundle) files.

### Current Supported Languages
- 🇬🇧 **English (en)** - Default
- 🇵🇰 **Urdu (ur)** - RTL support

---

## 📁 File Structure

```
lib/core/l10n/
├── app_en.arb                    # English translations (source)
├── app_ur.arb                    # Urdu translations (source)
├── app_localizations.dart        # Generated base class
├── app_localizations_en.dart     # Generated English class
├── app_localizations_ur.dart     # Generated Urdu class
└── app_localization_service.dart # Service for locale management

l10n.yaml                         # Localization configuration
```

### File Types Explained

| File | Type | Purpose | Edit? |
|------|------|---------|-------|
| `app_en.arb` | Source | English translations | ✅ Yes |
| `app_ur.arb` | Source | Urdu translations | ✅ Yes |
| `app_localizations_*.dart` | Generated | Dart code for translations | ❌ No |
| `app_localization_service.dart` | Service | Locale management utilities | ✅ Yes |

---

## ⚙️ How It Works

### 1. **Source Files (ARB)**
You edit `.arb` files (JSON format) with translations:

```json
{
  "@@locale": "en",
  "welcome": "Welcome",
  "@welcome": {
    "description": "Welcome message"
  }
}
```

### 2. **Generation**
Flutter automatically generates Dart classes from ARB files:
- `app_localizations.dart` - Base abstract class
- `app_localizations_en.dart` - English implementation
- `app_localizations_ur.dart` - Urdu implementation

### 3. **Configuration**
`l10n.yaml` configures the generation:

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/core/l10n
```

### 4. **Usage**
Access translations via `AppLocalizations.of(context)`:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.welcome); // "Welcome" or "خوش آمدید"
```

---

## ➕ Adding New Translations

### Step 1: Add to English ARB File

Edit `lib/core/l10n/app_en.arb`:

```json
{
  "@@locale": "en",
  "login": "Login",
  "@login": {
    "description": "Login button text"
  },
  "email": "Email",
  "@email": {
    "description": "Email field label"
  }
}
```

### Step 2: Add to Other Language Files

Edit `lib/core/l10n/app_ur.arb`:

```json
{
  "@@locale": "ur",
  "login": "لاگ ان",
  "email": "ای میل"
}
```

### Step 3: Regenerate

Run one of these commands:

```bash
# Option 1: Generate only
flutter gen-l10n

# Option 2: Get dependencies (also generates)
flutter pub get

# Option 3: Build (also generates)
flutter build apk
```

### Step 4: Use in Code

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.login);  // "Login" or "لاگ ان"
```

---

## 💻 Using Translations in Code

### Basic Usage

```dart
import 'package:fluttersampleachitecture/core/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Text(l10n.welcome);
  }
}
```

### With Null Safety

```dart
final l10n = AppLocalizations.of(context);
if (l10n != null) {
  return Text(l10n.welcome);
}
```

### In StatelessWidget

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: l10n.email),
          ),
        ],
      ),
    );
  }
}
```

### In StatefulWidget

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.welcome);
  }
}
```

### In Cubit/Bloc

```dart
class MyCubit extends Cubit<MyState> {
  void showMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use l10n.welcome, etc.
  }
}
```

---

## 🌐 Adding a New Language

### Step 1: Create ARB File

Create `lib/core/l10n/app_es.arb` for Spanish:

```json
{
  "@@locale": "es",
  "appTitle": "Arquitectura de Muestra Flutter",
  "welcome": "Bienvenido",
  "login": "Iniciar sesión"
}
```

### Step 2: Update Service

Edit `lib/core/l10n/app_localization_service.dart`:

```dart
static const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('ur'),
  Locale('es'), // Add new language
];

static String getLocaleName(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'ur':
      return 'اردو';
    case 'es':
      return 'Español'; // Add display name
    default:
      return locale.languageCode;
  }
}

static bool isRTL(Locale locale) {
  return locale.languageCode == 'ur'; // Add RTL languages if needed
}
```

### Step 3: Regenerate

```bash
flutter gen-l10n
```

This will create `app_localizations_es.dart` automatically.

### Step 4: Update App Configuration

The generated `app_localizations.dart` will automatically include the new language in `supportedLocales`.

---

## 🔄 Changing Language at Runtime

### Using AppCubit

The app uses `AppCubit` to manage locale changes:

```dart
// Change language
context.read<AppCubit>().changeLocale(Locale('ur'));

// Get current locale
final currentLocale = context.read<AppCubit>().state.locale;
```

### Using AppLocalizationService

```dart
import 'package:fluttersampleachitecture/core/l10n/app_localization_service.dart';

// Get saved locale
final locale = AppLocalizationService.getSavedLocale();

// Save locale
await AppLocalizationService.setLocale(Locale('ur'));

// Get locale name
final name = AppLocalizationService.getLocaleName(Locale('ur')); // "اردو"

// Check if RTL
final isRTL = AppLocalizationService.isRTL(Locale('ur')); // true
```

### Example: Language Selection Bottom Sheet

```dart
// Show language selection
LocaleBottomSheet.show(context);

// Or manually change
context.read<AppCubit>().changeLocale(Locale('ur'));
```

---

## ✅ Best Practices

### 1. **Always Use ARB Files**
- ✅ Edit `.arb` files
- ❌ Don't edit generated `.dart` files

### 2. **Keep Keys Consistent**
- Use camelCase: `loginButton`, `welcomeMessage`
- Be descriptive: `loginButton` not `btn1`

### 3. **Add Descriptions**
```json
{
  "login": "Login",
  "@login": {
    "description": "Login button text for authentication screen"
  }
}
```

### 4. **Handle Missing Translations**
Flutter falls back to the template locale (English) if a translation is missing.

### 5. **Test All Languages**
Always test your app in all supported languages, especially RTL languages.

### 6. **Use Context-Aware Translations**
```dart
// Good: Context-aware
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome);

// Bad: Hard-coded
Text('Welcome');
```

### 7. **Organize by Feature**
Group related translations:
```json
{
  "auth_login": "Login",
  "auth_logout": "Logout",
  "auth_forgotPassword": "Forgot Password",
  "profile_name": "Name",
  "profile_email": "Email"
}
```

---

## 🔧 Troubleshooting

### Problem: Translations Not Updating

**Solution:**
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter gen-l10n
```

### Problem: "AppLocalizations.of(context) returns null"

**Solution:**
Ensure `MaterialApp.router` includes delegates:

```dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

### Problem: Generated Files Not Created

**Solution:**
1. Check `l10n.yaml` configuration
2. Ensure `pubspec.yaml` has:
   ```yaml
   flutter:
     generate: true
   ```
3. Run `flutter gen-l10n`

### Problem: RTL Not Working

**Solution:**
1. Check `AppLocalizationService.isRTL()` returns true for RTL languages
2. Ensure `Directionality` widget wraps content if needed
3. Test with actual RTL language (Urdu)

### Problem: Missing Translation Key

**Solution:**
1. Add key to all `.arb` files
2. Regenerate: `flutter gen-l10n`
3. Restart app

---

## 📚 Examples

### Example 1: Login Screen

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: l10n.email,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Dynamic Language Switch

```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.watch<AppCubit>().state.locale,
      items: AppLocalizationService.supportedLocales.map((locale) {
        return DropdownMenuItem(
          value: locale,
          child: Text(AppLocalizationService.getLocaleName(locale)),
        );
      }).toList(),
      onChanged: (locale) {
        if (locale != null) {
          context.read<AppCubit>().changeLocale(locale);
        }
      },
    );
  }
}
```

### Example 3: RTL Support

```dart
class MyRTLWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = AppLocalizationService.isRTL(l10n.localeName);
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Text(l10n.welcome),
    );
  }
}
```

---

## 🎯 Quick Reference

### Commands

```bash
# Generate localizations
flutter gen-l10n

# Get dependencies (also generates)
flutter pub get

# Clean and regenerate
flutter clean && flutter pub get
```

### File Locations

- **Source files**: `lib/core/l10n/*.arb`
- **Generated files**: `lib/core/l10n/app_localizations*.dart`
- **Service**: `lib/core/l10n/app_localization_service.dart`
- **Config**: `l10n.yaml`

### Key Classes

- `AppLocalizations` - Base class for translations
- `AppLocalizationService` - Locale management utilities
- `AppCubit` - State management for locale changes

---

## 📝 Summary

1. ✅ Edit `.arb` files to add/update translations
2. ✅ Run `flutter gen-l10n` to generate Dart code
3. ✅ Use `AppLocalizations.of(context)!` to access translations
4. ✅ Use `AppCubit.changeLocale()` to change language at runtime
5. ✅ Test in all supported languages

---

**Need Help?** Check the [Flutter Localization Documentation](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
