import 'package:flutter/material.dart';

/// Custom button with loading state
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? style;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.style,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed =
        (isEnabled && !isLoading && onPressed != null) ? onPressed : null;

    Widget buttonContent;
    if (isLoading) {
      buttonContent = SizedBox(
        height: height ?? 20,
        width: height ?? 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    } else if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      buttonContent = Text(text);
    }

    final button = ElevatedButton(
      onPressed: effectiveOnPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (effectiveOnPressed != null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface),
            foregroundColor: textColor ??
                (effectiveOnPressed != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface),
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(width ?? 0, height ?? 48),
          ),
      child: buttonContent,
    );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}

/// Custom text button
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final Widget? icon;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Custom outlined button
class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? Theme.of(context).colorScheme.primary,
        side: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

