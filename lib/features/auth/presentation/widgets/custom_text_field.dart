import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';

/// Custom text field with common configurations
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool required;
  final bool isEmail;
  final bool isPassword;
  final bool isPhone;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.validator,
    this.required = false,
    this.isEmail = false,
    this.isPassword = false,
    this.isPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ??
          (isEmail
              ? TextInputType.emailAddress
              : isPhone
                  ? TextInputType.phone
                  : null),
      obscureText: obscureText || isPassword,
      enabled: enabled,
      maxLines: obscureText || isPassword ? 1 : maxLines,
      maxLength: maxLength,
      focusNode: focusNode,
      textInputAction: textInputAction ??
          (maxLines == 1 ? TextInputAction.next : TextInputAction.newline),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator ??
          (required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '${labelText ?? 'This field'} is required';
                  }
                  if (isEmail) {
                    return Validators.email(value);
                  }
                  if (isPassword) {
                    return Validators.password(value);
                  }
                  if (isPhone) {
                    return Validators.phoneNumber(value);
                  }
                  return null;
                }
              : null),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        filled: true,
        fillColor: enabled
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
      ),
    );
  }
}

