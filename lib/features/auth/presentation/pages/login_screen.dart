import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleachitecture/core/preference/app_pref.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/widgets_export.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/enums/state_status.dart';
import '../widgets/remember_me_forgot_password_row_widget.dart';
import '../widgets/sign_up_row_widget.dart';
import '../widgets/welcome_back_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginDataFeeder();
   var aa= sl<AppPref>().getString("Test");
   print(aa.toString());
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.paddingXXL),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo/Icon
                    AppLogoWidget(),
                    SizedBox(height: AppSizes.spacingXXXL),
                    // Welcome Text
                    WelcomeBackWidget(),
                    SizedBox(height: AppSizes.spacingXXXL),
                    // Email Field
                    AppEmailField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      onSubmitted: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_passwordFocusNode);
                      },
                    ),
                    SizedBox(height: AppSizes.spacingL),
                    // Password Field
                    AppPasswordField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      onSubmitted: (_) => _handleLogin(context),
                    ),
                    SizedBox(height: AppSizes.spacingM),
                    // Remember Me & Forgot Password Row
                    RememberMeForgotPasswordRowWidget(),
                    SizedBox(height: AppSizes.spacingXXXL),
                    BlocSelector<AuthCubit, AuthState, StateStatus>(
                      selector: (state) => state.loginStatus,
                      builder: (context, loginStatus) {
                        return AppButton(
                          text: AppStrings.signIn,
                          onPressed: () => _handleLogin(context),
                          isLoading: loginStatus == StateStatus.loading,
                          icon: Icons.arrow_forward_rounded,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.spacingXXL),
                    // Sign Up Link
                    SignUpRowWidget(colorScheme: colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _handleLogin(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      SharedAppData.setValue(context, "test", "Value from SharedAppData");

      context.read<AuthCubit>().loginUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void loginDataFeeder
      () {
  _emailController.text="test@gmail.com";
  _passwordController.text="Test@1122";
  }
}
