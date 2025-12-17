import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../widgets/error_widget.dart';
import 'auth_state.dart';
import 'state_status.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(const AuthState());

  /// Login user with email and password
  ///
  /// Shows error messages via snackbar and handles navigation on success
  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(loginStatus: StateStatus.loading));

    final params = LoginParams(email: email, password: password);
    final result = await loginUseCase.call(params);

    result.fold(
      // Left: Error
      (error) {
        emit(state.copyWith(loginStatus: StateStatus.error));
        ErrorSnackBar.show(context, error);
      },
      // Right: Success
      (response) {
        // Add any response validation here if needed
        // Example: if (response.networkType == null) { ... }

        emit(
          state.copyWith(
            loginStatus: StateStatus.success,
            loginEntity: response,
          ),
        );

        // Navigate to next screen (e.g., verify OTP or home)
        // Example: context.push('/verify-otp', extra: {'data': response, 'email': email});
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(verifyOtpState: StateStatus.loading));

    try {
      // TODO: Implement verify OTP use case
      // final result = await verifyOtpUseCase(otp);
      emit(state.copyWith(verifyOtpState: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(verifyOtpState: StateStatus.error));
    }
  }

  void reset() {
    emit(const AuthState());
  }

  void resetLoginStatus() {
    emit(state.copyWith(loginStatus: StateStatus.idle));
  }

  void resetVerifyOtpState() {
    emit(state.copyWith(verifyOtpState: StateStatus.idle));
  }
}
