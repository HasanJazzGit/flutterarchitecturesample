# Form Widgets Guide

## Overview

This guide explains how to use the reusable form widgets available in `core/widgets/`. These widgets provide consistent styling, validation, and behavior across the entire app.

## Available Widgets

1. **AppTextField** - Base text field widget
2. **AppEmailField** - Email-specific text field
3. **AppPasswordField** - Password field with show/hide toggle
4. **AppNameField** - Name field with validation
5. **AppFirstNameField** - First name field
6. **AppButton** - Reusable button widget

---

## 1. AppTextField

Base text field widget with full customization options.

### Usage

```dart
import 'package:fluttersampleachitecture/core/widgets/widgets_export.dart';

AppTextField(
  controller: _controller,
  labelText: 'Label',
  hintText: 'Hint text',
  prefixIcon: Icons.person,
  validator: (value) => Validators.required(value),
  onChanged: (value) {
    // Handle change
  },
)
```

### Parameters

- `controller` - TextEditingController
- `labelText` - Field label
- `hintText` - Placeholder text
- `prefixIcon` - Icon before text
- `suffixIcon` - Widget after text
- `obscureText` - Hide text (for passwords)
- `keyboardType` - Keyboard type
- `validator` - Validation function
- `onChanged` - Change callback
- `onSubmitted` - Submit callback
- `focusNode` - Focus node
- `enabled` - Enable/disable field
- `maxLines` - Number of lines
- `maxLength` - Maximum character length

---

## 2. AppEmailField

Pre-configured email field with email validation.

### Usage

```dart
AppEmailField(
  controller: _emailController,
  focusNode: _emailFocusNode,
  onSubmitted: (_) {
    // Move to next field
  },
)
```

### Features

- ✅ Email keyboard type
- ✅ Email validation (using `Validators.email()`)
- ✅ Email icon
- ✅ Autofill support
- ✅ Next action on keyboard

### Example

```dart
final _emailController = TextEditingController();
final _emailFocusNode = FocusNode();

AppEmailField(
  controller: _emailController,
  focusNode: _emailFocusNode,
  textInputAction: TextInputAction.next,
  onSubmitted: (_) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  },
)
```

---

## 3. AppPasswordField

Password field with show/hide toggle.

### Usage

```dart
AppPasswordField(
  controller: _passwordController,
  focusNode: _passwordFocusNode,
  onSubmitted: (_) => _handleSubmit(),
)
```

### Features

- ✅ Password validation (using `Validators.password()`)
- ✅ Show/hide password toggle
- ✅ Lock icon
- ✅ Autofill support
- ✅ Done action on keyboard

### Parameters

- `showVisibilityToggle` - Show/hide toggle button (default: true)
- All standard text field parameters

### Example

```dart
final _passwordController = TextEditingController();
final _passwordFocusNode = FocusNode();

AppPasswordField(
  controller: _passwordController,
  focusNode: _passwordFocusNode,
  textInputAction: TextInputAction.done,
  onSubmitted: (_) => _handleLogin(),
)
```

---

## 4. AppNameField

Name field with name validation.

### Usage

```dart
AppNameField(
  controller: _nameController,
  fieldName: 'Full Name', // Optional, defaults to 'Name'
  isRequired: true, // Optional, defaults to true
)
```

### Features

- ✅ Name validation (using `Validators.name()`)
- ✅ Person icon
- ✅ Autofill support
- ✅ Customizable field name

### Example

```dart
AppNameField(
  controller: _nameController,
  labelText: 'Full Name',
  fieldName: 'Full name',
  isRequired: true,
)
```

---

## 5. AppFirstNameField

First name field with validation.

### Usage

```dart
AppFirstNameField(
  controller: _firstNameController,
)
```

### Features

- ✅ First name validation
- ✅ Person icon
- ✅ Autofill support (givenName)
- ✅ Next action on keyboard

### Example

```dart
AppFirstNameField(
  controller: _firstNameController,
  focusNode: _firstNameFocusNode,
  textInputAction: TextInputAction.next,
  onSubmitted: (_) {
    FocusScope.of(context).requestFocus(_lastNameFocusNode);
  },
)
```

---

## 6. AppButton

Reusable button widget with multiple styles.

### Usage

#### Primary Button (Filled)

```dart
AppButton.primary(
  text: 'Sign In',
  onPressed: () => _handleLogin(),
  icon: Icons.arrow_forward,
  isLoading: false,
)
```

#### Secondary Button (Outlined)

```dart
AppButton.secondary(
  text: 'Cancel',
  onPressed: () => _handleCancel(),
)
```

#### Text Button

```dart
AppButton.text(
  text: 'Forgot Password?',
  onPressed: () => _handleForgotPassword(),
)
```

#### Custom Button

```dart
AppButton(
  text: 'Custom',
  onPressed: () {},
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  height: 60,
  borderRadius: 16,
)
```

### Features

- ✅ Loading state with spinner
- ✅ Icon support
- ✅ Customizable colors
- ✅ Customizable size
- ✅ Three styles: primary, secondary, text

### Parameters

- `text` - Button text (required)
- `onPressed` - Press callback
- `isLoading` - Show loading spinner
- `icon` - Icon to display
- `backgroundColor` - Background color
- `foregroundColor` - Text/icon color
- `height` - Button height
- `width` - Button width
- `borderRadius` - Border radius
- `fontSize` - Text size
- `fontWeight` - Text weight

### Example with Loading

```dart
BlocSelector<AuthCubit, AuthState, StateStatus>(
  selector: (state) => state.loginStatus,
  builder: (context, loginStatus) {
    return AppButton.primary(
      text: 'Sign In',
      onPressed: () => _handleLogin(),
      isLoading: loginStatus == StateStatus.loading,
      icon: Icons.arrow_forward,
    );
  },
)
```

---

## Complete Form Example

```dart
import 'package:flutter/material.dart';
import 'package:fluttersampleachitecture/core/widgets/widgets_export.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name
          AppFirstNameField(
            controller: _firstNameController,
            focusNode: _firstNameFocusNode,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_lastNameFocusNode);
            },
          ),
          SizedBox(height: AppSizes.spacingL),

          // Last Name
          AppNameField(
            controller: _lastNameController,
            labelText: 'Last Name',
            fieldName: 'Last name',
            focusNode: _lastNameFocusNode,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailFocusNode);
            },
          ),
          SizedBox(height: AppSizes.spacingL),

          // Email
          AppEmailField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
          ),
          SizedBox(height: AppSizes.spacingL),

          // Password
          AppPasswordField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
          ),
          SizedBox(height: AppSizes.spacingL),

          // Confirm Password
          AppPasswordField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            focusNode: _confirmPasswordFocusNode,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: AppSizes.spacingXXXL),

          // Submit Button
          AppButton.primary(
            text: 'Register',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle registration
              }
            },
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }
}
```

---

## Login Screen Example (Updated)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleachitecture/core/widgets/widgets_export.dart';
import 'package:fluttersampleachitecture/core/constants/app_sizes.dart';
import 'package:fluttersampleachitecture/core/constants/app_strings.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email Field
            AppEmailField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            SizedBox(height: AppSizes.spacingL),

            // Password Field
            AppPasswordField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              onSubmitted: (_) => _handleLogin(),
            ),
            SizedBox(height: AppSizes.spacingXXXL),

            // Login Button
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return AppButton.primary(
                  text: AppStrings.signIn,
                  onPressed: () => _handleLogin(),
                  isLoading: state.loginStatus == StateStatus.loading,
                  icon: Icons.arrow_forward,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
```

---

## Best Practices

1. **Always use FocusNodes** for proper keyboard navigation
2. **Use textInputAction** to control keyboard behavior
3. **Validate on submit** using Form's validate method
4. **Dispose controllers** in dispose method
5. **Use AppSizes** for consistent spacing
6. **Use AppStrings** for all text
7. **Handle loading states** in buttons

---

## Customization

All widgets can be customized:

```dart
// Custom email field
AppEmailField(
  controller: _emailController,
  labelText: 'Work Email', // Custom label
  hintText: 'Enter work email', // Custom hint
  validator: (value) {
    // Custom validation
    if (value?.contains('@company.com') != true) {
      return 'Must be a company email';
    }
    return Validators.email(value);
  },
)

// Custom button
AppButton(
  text: 'Custom',
  onPressed: () {},
  backgroundColor: Colors.purple,
  foregroundColor: Colors.white,
  height: 60,
  borderRadius: 20,
  fontSize: 18,
  fontWeight: FontWeight.w600,
)
```

---

## Benefits

✅ **Consistency** - Same look and feel across the app  
✅ **Reusability** - Use anywhere in the app  
✅ **Maintainability** - Update once, applies everywhere  
✅ **Validation** - Built-in validation using Validators  
✅ **Accessibility** - Proper autofill hints and keyboard types  
✅ **Theme Support** - Automatically adapts to light/dark theme  

---

**Happy Coding! 🚀**
