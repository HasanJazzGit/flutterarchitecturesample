import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

/// Extension on BuildContext for easy access to theme colors
extension AppColorsExtension on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
}

/// Extension on BuildContext for easy access to theme
extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}

/// Extension on String for common string operations
extension StringExtension on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s-]'), ''));
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && (uri.hasAuthority || uri.path.isNotEmpty);
    } catch (e) {
      return false;
    }
  }

  /// Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Check if string is alphanumeric
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Check if string contains only letters
  bool get isLettersOnly {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove special characters (keep only alphanumeric and spaces)
  String get removeSpecialChars =>
      replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');

  /// Truncate string to specified length with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Truncate string to specified length from start
  String truncateStart(int maxLength, {String prefix = '...'}) {
    if (length <= maxLength) return this;
    return '$prefix${substring(length - maxLength)}';
  }

  /// Extract numbers from string
  String get extractNumbers => replaceAll(RegExp(r'[^0-9]'), '');

  /// Extract letters from string
  String get extractLetters => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  /// Mask string (e.g., email, phone)
  String mask({int start = 0, int end = 0, String maskChar = '*'}) {
    if (length <= start + end) return this;
    final visibleStart = substring(0, start);
    final visibleEnd = substring(length - end);
    final masked = maskChar * (length - start - end);
    return '$visibleStart$masked$visibleEnd';
  }

  /// Mask email (e.g., j***@example.com)
  String get maskEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 1) return this;
    final maskedUsername = '${username[0]}${'*' * (username.length - 1)}';
    return '$maskedUsername@$domain';
  }

  /// Mask phone number (e.g., +123****5678)
  String get maskPhone {
    final numbers = extractNumbers;
    if (numbers.length < 4) return this;
    final visible = numbers.substring(numbers.length - 4);
    final masked = '*' * (numbers.length - 4);
    return '$masked$visible';
  }

  /// Check if string is empty or null (after trim)
  bool get isEmptyOrNull => trim().isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => !isEmpty;

  /// Get initials from name (e.g., "John Doe" -> "JD")
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  /// Convert to slug (e.g., "Hello World" -> "hello-world")
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Convert camelCase to snake_case
  String get camelToSnake {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }

  /// Convert snake_case to camelCase
  String get snakeToCamel {
    return split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  /// Pad string to specified length
  String pad(int length, {String padChar = ' ', bool padLeft = false}) {
    if (this.length >= length) return this;
    final padding = padChar * (length - this.length);
    return padLeft ? '$padding$this' : '$this$padding';
  }

  /// Remove HTML tags
  String get removeHtmlTags => replaceAll(RegExp(r'<[^>]*>'), '');

  /// Count words
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Check if string contains any of the given strings
  bool containsAny(List<String> strings) {
    return strings.any((s) => contains(s));
  }

  /// Check if string contains all of the given strings
  bool containsAll(List<String> strings) {
    return strings.every((s) => contains(s));
  }
}

/// Extension on DateTime for formatting
extension DateTimeExtension on DateTime {
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }
}

