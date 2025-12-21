import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../utils/validators.dart';
import 'app_text_field.dart';

/// Reusable password text field widget with show/hide toggle
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool showVisibilityToggle;

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.textInputAction,
    this.autofocus = false,
    this.showVisibilityToggle = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText ?? AppStrings.password,
      hintText: widget.hintText ?? AppStrings.enterPassword,
      prefixIcon: Icons.lock_outline,
      suffixIcon: widget.showVisibilityToggle
          ? IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
            )
          : null,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      validator: widget.validator ?? (value) => Validators.password(value),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      autofillHints: AutofillHints.password,
    );
  }
}
