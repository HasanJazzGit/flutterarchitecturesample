import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart' show AppStrings;
import '../../../../core/utils/extensions.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RememberMeForgotPasswordRowWidget extends StatelessWidget {
  const RememberMeForgotPasswordRowWidget({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.rememberMe,
      builder: (context, rememberMe) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {

                    context.read<AuthCubit>().toggleRememberMe(value ?? false);
                  },
                  activeColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                  ),
                ),
                Text(
                  "Remember Me",
                  style: TextStyle(
                    fontSize: AppSizes.textSizeM,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Forgot Password"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: AppSizes.textSizeM,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
