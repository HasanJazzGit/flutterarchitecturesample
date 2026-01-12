import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class WelcomeBackWidget extends StatelessWidget {
  const WelcomeBackWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Text(
          "Welcome Back'",
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacingS),
        Text(
          "Sign In",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.7),
            fontSize: AppSizes.textSizeL,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}