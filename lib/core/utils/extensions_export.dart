// Export all extensions in one place
//
// Usage:
// ```dart
// import 'package:your_app/core/utils/extensions_export.dart';
// ```
//
// This will import all extensions:
// - Size extensions (MediaQuery, responsive sizing, spacing)
// - Text extensions (TextTheme, text sizing, TextStyle builders)
// - String extensions (validation, formatting, manipulation)
// - Number extensions (formatting, currency, file size, etc.)
// - DateTime extensions (date/time formatting)
// - Theme extensions (AppColors, theme checks)

// Size and MediaQuery extensions
export 'size_extensions.dart';

// Text and TextStyle extensions
export 'text_extensions.dart';

// String extensions
export 'extensions.dart' show StringExtension, DateTimeExtension;

// Number extensions
export 'number_extensions.dart';

// Theme extensions (from extensions.dart)
export 'extensions.dart' show AppColorsExtension, ThemeExtension;

