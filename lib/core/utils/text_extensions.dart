import 'package:flutter/material.dart';

/// Text style extensions for easy access to text themes
extension TextStyleExtension on BuildContext {
  /// Get TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Display styles
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  /// Headline styles
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  /// Title styles
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  /// Body styles
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  /// Label styles
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}

/// Text size extensions for responsive text sizing
extension TextSizeExtension on BuildContext {
  /// Get responsive text size
  double textSize(double baseSize) {
    final scale = MediaQuery.of(this).textScaler.scale(1.0);
    return baseSize * scale;
  }

  /// Small text size (12)
  double get textSizeXS => textSize(12);

  /// Small text size (14)
  double get textSizeS => textSize(14);

  /// Medium text size (16)
  double get textSizeM => textSize(16);

  /// Large text size (18)
  double get textSizeL => textSize(18);

  /// Extra large text size (20)
  double get textSizeXL => textSize(20);

  /// Extra extra large text size (24)
  double get textSizeXXL => textSize(24);

  /// Huge text size (28)
  double get textSizeHuge => textSize(28);

  /// Giant text size (32)
  double get textSizeGiant => textSize(32);

  /// Massive text size (40)
  double get textSizeMassive => textSize(40);
}

/// TextStyle builder extensions
extension TextStyleBuilderExtension on TextStyle {
  /// Copy with color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Copy with size
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// Copy with weight
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// Copy with italic
  TextStyle withItalic(bool italic) => copyWith(fontStyle: italic ? FontStyle.italic : FontStyle.normal);

  /// Copy with decoration
  TextStyle withDecoration(TextDecoration decoration) =>
      copyWith(decoration: decoration);

  /// Copy with letter spacing
  TextStyle withLetterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);

  /// Copy with height
  TextStyle withHeight(double height) => copyWith(height: height);

  /// Make bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Make italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Make underline
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  /// Make strikethrough
  TextStyle get strikethrough =>
      copyWith(decoration: TextDecoration.lineThrough);
}

