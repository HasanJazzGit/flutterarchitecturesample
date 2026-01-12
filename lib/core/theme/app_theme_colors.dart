import 'package:flutter/material.dart';

/// App color extensions for Material 3
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color yourCustomColorName;
  
  final Color? textTertiary;
  final Color? iconColor;

  const AppThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.yourCustomColorName,
    this.textTertiary,
    this.iconColor,
  });

  /// Light theme colors
  static const AppThemeColors light = AppThemeColors(
    primary: Color(0xFF6750A4),
    secondary: Color(0xFF625B71),
    background: Color(0xFFFFFBFE),
    yourCustomColorName: Color(0xFF4CAF50),
    textTertiary: Color(0xFF9E9E9E),
    iconColor: Color(0xFF212121),
  );

  /// Dark theme colors
  static const AppThemeColors dark = AppThemeColors(
    primary: Color(0xFFD0BCFF),
    secondary: Color(0xFFCCC2DC),
    background: Color(0xFF1C1B1F),
    yourCustomColorName: Color(0xFF690005),
    textTertiary: Color(0xFF808080),
    iconColor: Color(0xFFE0E0E0),
  );

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? yourCustomColorName,
    Color? textTertiary,
    Color? iconColor,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      yourCustomColorName: yourCustomColorName ?? this.yourCustomColorName,
      textTertiary: textTertiary ?? this.textTertiary,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      yourCustomColorName:
      Color.lerp(yourCustomColorName, other.yourCustomColorName, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}
