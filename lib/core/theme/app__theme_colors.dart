import 'package:flutter/material.dart';

/// App color extensions for Material 3
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;

  final Color newCustomColor;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color surface;
  final Color background;
  final Color onPrimary;
  final Color onSecondary;
  final Color onTertiary;
  final Color onError;
  final Color onSurface;
  final Color onBackground;

  // Custom colors - Status colors
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? divider;
  final Color? border;
  final Color? shadow;
  final Color? disabled;
  final Color? hint;

  // Custom colors - Additional UI colors
  final Color? cardBackground;
  final Color? scaffoldBackground;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? textTertiary;
  final Color? iconColor;
  final Color? iconSecondary;
  
  // Custom colors - Brand colors
  final Color? brandPrimary;
  final Color? brandSecondary;
  final Color? brandAccent;
  
  // Custom colors - Semantic colors
  final Color? link;
  final Color? visited;
  final Color? highlight;
  final Color? selected;
  
  // Custom colors - Background colors
  final Color? backgroundPrimary;
  final Color? backgroundSecondary;
  final Color? backgroundTertiary;
  
  // Custom colors - Overlay colors
  final Color? overlay;
  final Color? overlayDark;

  const AppThemeColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.surface,
    required this.background,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    required this.onError,
    required this.onSurface,
    required this.onBackground,
    required this.newCustomColor,
    this.success,
    this.warning,
    this.info,
    this.divider,
    this.border,
    this.shadow,
    this.disabled,
    this.hint,
    this.cardBackground,
    this.scaffoldBackground,
    this.textPrimary,
    this.textSecondary,
    this.textTertiary,
    this.iconColor,
    this.iconSecondary,
    this.brandPrimary,
    this.brandSecondary,
    this.brandAccent,
    this.link,
    this.visited,
    this.highlight,
    this.selected,
    this.backgroundPrimary,
    this.backgroundSecondary,
    this.backgroundTertiary,
    this.overlay,
    this.overlayDark,
  });

  // Light theme colors
  static const AppThemeColors light = AppThemeColors(
    primary: Color(0xFF6750A4),
    secondary: Color(0xFF625B71),
    tertiary: Color(0xFF7D5260),
    error: Color(0xFFBA1A1A),
    surface: Color(0xFFFFFBFE),
    background: Color(0xFFFFFBFE),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onTertiary: Color(0xFFFFFFFF),
    onError: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    onBackground: Color(0xFF1C1B1F),
    newCustomColor: Color(0xFF1C1B1F),
    // Custom colors
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    info: Color(0xFF2196F3),
    divider: Color(0xFFE0E0E0),
    border: Color(0xFFBDBDBD),
    shadow: Color(0x1A000000),
    disabled: Color(0xFF9E9E9E),
    hint: Color(0xFF757575),
    // Additional UI colors
    cardBackground: Color(0xFFFFFFFF),
    scaffoldBackground: Color(0xFFF5F5F5),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    textTertiary: Color(0xFF9E9E9E),
    iconColor: Color(0xFF212121),
    iconSecondary: Color(0xFF757575),
    // Brand colors
    brandPrimary: Color(0xFF6750A4),
    brandSecondary: Color(0xFF625B71),
    brandAccent: Color(0xFF7D5260),
    // Semantic colors
    link: Color(0xFF1976D2),
    visited: Color(0xFF7B1FA2),
    highlight: Color(0xFFFFEB3B),
    selected: Color(0xFFE3F2FD),
    // Background colors
    backgroundPrimary: Color(0xFFFFFBFE),
    backgroundSecondary: Color(0xFFF5F5F5),
    backgroundTertiary: Color(0xFFEEEEEE),
    // Overlay colors
    overlay: Color(0x1A000000),
    overlayDark: Color(0x66000000),
  );

  // Dark theme colors
  static const AppThemeColors dark = AppThemeColors(
    primary: Color(0xFFD0BCFF),
    secondary: Color(0xFFCCC2DC),
    tertiary: Color(0xFFEFB8C8),
    error: Color(0xFFFFB4AB),
    surface: Color(0xFF1C1B1F),
    background: Color(0xFF1C1B1F),
    onPrimary: Color(0xFF381E72),
    onSecondary: Color(0xFF332D41),
    onTertiary: Color(0xFF492532),
    onError: Color(0xFF690005),
    onSurface: Color(0xFFE6E1E5),
    onBackground: Color(0xFFE6E1E5),
    newCustomColor: Color(0xFF1C1B1F),
    // Custom colors
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFA726),
    info: Color(0xFF42A5F5),
    divider: Color(0xFF424242),
    border: Color(0xFF616161),
    shadow: Color(0x40000000),
    disabled: Color(0xFF757575),
    hint: Color(0xFF9E9E9E),
    // Additional UI colors
    cardBackground: Color(0xFF2C2C2C),
    scaffoldBackground: Color(0xFF121212),
    textPrimary: Color(0xFFE0E0E0),
    textSecondary: Color(0xFFB0B0B0),
    textTertiary: Color(0xFF808080),
    iconColor: Color(0xFFE0E0E0),
    iconSecondary: Color(0xFFB0B0B0),
    // Brand colors
    brandPrimary: Color(0xFFD0BCFF),
    brandSecondary: Color(0xFFCCC2DC),
    brandAccent: Color(0xFFEFB8C8),
    // Semantic colors
    link: Color(0xFF90CAF9),
    visited: Color(0xFFCE93D8),
    highlight: Color(0xFFFFF59D),
    selected: Color(0xFF424242),
    // Background colors
    backgroundPrimary: Color(0xFF1C1B1F),
    backgroundSecondary: Color(0xFF2C2C2C),
    backgroundTertiary: Color(0xFF3C3C3C),
    // Overlay colors
    overlay: Color(0x40000000),
    overlayDark: Color(0x80000000),
  );

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? error,
    Color? surface,
    Color? background,
    Color? onPrimary,
    Color? onSecondary,
    Color? onTertiary,
    Color? onError,
    Color? onSurface,
    Color? onBackground,
    Color? success,
    Color? warning,
    Color? info,
    Color? divider,
    Color? border,
    Color? shadow,
    Color? disabled,
    Color? hint,
    Color? cardBackground,
    Color? scaffoldBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? iconColor,
    Color? iconSecondary,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandAccent,
    Color? link,
    Color? visited,
    Color? highlight,
    Color? selected,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? overlay,
    Color? overlayDark,
  }) {
    return AppThemeColors(
      newCustomColor: Color(0xFF1C1B1F),
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      error: error ?? this.error,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onTertiary: onTertiary ?? this.onTertiary,
      onError: onError ?? this.onError,
      onSurface: onSurface ?? this.onSurface,
      onBackground: onBackground ?? this.onBackground,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      disabled: disabled ?? this.disabled,
      hint: hint ?? this.hint,
      cardBackground: cardBackground ?? this.cardBackground,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      iconColor: iconColor ?? this.iconColor,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandAccent: brandAccent ?? this.brandAccent,
      link: link ?? this.link,
      visited: visited ?? this.visited,
      highlight: highlight ?? this.highlight,
      selected: selected ?? this.selected,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
      overlay: overlay ?? this.overlay,
      overlayDark: overlayDark ?? this.overlayDark,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      newCustomColor: Color(0xFF1C1B1F),
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      error: Color.lerp(error, other.error, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      divider: Color.lerp(divider, other.divider, t),
      border: Color.lerp(border, other.border, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      disabled: Color.lerp(disabled, other.disabled, t),
      hint: Color.lerp(hint, other.hint, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t),
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t),
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t),
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t),
      link: Color.lerp(link, other.link, t),
      visited: Color.lerp(visited, other.visited, t),
      highlight: Color.lerp(highlight, other.highlight, t),
      selected: Color.lerp(selected, other.selected, t),
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t),
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t),
      backgroundTertiary: Color.lerp(backgroundTertiary, other.backgroundTertiary, t),
      overlay: Color.lerp(overlay, other.overlay, t),
      overlayDark: Color.lerp(overlayDark, other.overlayDark, t),
    );
  }
}

