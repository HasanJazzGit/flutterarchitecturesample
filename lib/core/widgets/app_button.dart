import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Reusable button widget for the entire app
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final bool isOutlined;
  final bool isTextButton;
  final MainAxisAlignment? iconAlignment;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.isOutlined = false,
    this.isTextButton = false,
    this.iconAlignment,
    this.fontSize,
    this.fontWeight,
  });

  /// Primary button (filled with primary color)
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.iconAlignment,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
  }) : isOutlined = false,
       isTextButton = false;

  /// Secondary button (outlined)
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.iconAlignment,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
  }) : isOutlined = true,
       isTextButton = false;

  /// Text button (no background)
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.iconAlignment,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
  }) : isOutlined = false,
       isTextButton = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ??
        (isOutlined || isTextButton ? Colors.transparent : colorScheme.primary);
    final effectiveForegroundColor =
        foregroundColor ??
        (isOutlined || isTextButton
            ? colorScheme.primary
            : colorScheme.onPrimary);
    final effectiveHeight = height ?? AppSizes.buttonHeightL;
    final effectiveBorderRadius = borderRadius ?? AppSizes.radiusM;
    final effectiveElevation = elevation ?? (isLoading ? 0 : 2);
    final effectiveFontSize = fontSize ?? AppSizes.textSizeL;
    final effectiveFontWeight = fontWeight ?? FontWeight.bold;

    final buttonContent = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveForegroundColor,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: iconAlignment ?? MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: effectiveFontSize,
                  fontWeight: effectiveFontWeight,
                  letterSpacing: 0.5,
                  color: effectiveForegroundColor,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: AppSizes.paddingS),
                Icon(icon, size: 20, color: effectiveForegroundColor),
              ],
            ],
          );

    if (isTextButton) {
      return SizedBox(
        height: effectiveHeight,
        width: width,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveForegroundColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: buttonContent,
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        height: effectiveHeight,
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveForegroundColor,
            side: BorderSide(color: effectiveForegroundColor, width: 1.5),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            disabledForegroundColor: effectiveForegroundColor.withOpacity(0.6),
          ),
          child: buttonContent,
        ),
      );
    }

    return SizedBox(
      height: effectiveHeight,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: effectiveElevation,
          shadowColor: effectiveBackgroundColor.withOpacity(0.3),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          disabledBackgroundColor: effectiveBackgroundColor.withOpacity(0.6),
        ),
        child: buttonContent,
      ),
    );
  }
}
