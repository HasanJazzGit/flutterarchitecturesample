import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../utils/validators.dart';
import 'app_text_field.dart';

/// Reusable name text field widget
class AppNameField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? fieldName;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool isRequired;

  const AppNameField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.fieldName,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.textInputAction,
    this.autofocus = false,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText ?? (fieldName ?? 'Name'),
      hintText: hintText ?? 'Enter ${fieldName ?? 'name'}',
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator:
          validator ??
          (value) => Validators.name(
            value,
            fieldName: fieldName,
            isRequired: isRequired,
          ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      autofillHints: AutofillHints.name,
    );
  }
}
