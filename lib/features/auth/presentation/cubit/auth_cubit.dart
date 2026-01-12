import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersampleachitecture/core/router/app_routes.dart';
import 'package:fluttersampleachitecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fluttersampleachitecture/core/widgets/error_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/preference/app_pref.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(const AuthState());

  /// Toggle remember me checkbox
  void toggleRememberMe(bool value) {

    emit(state.copyWith(rememberMe: value));
  }

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
      (response) async {
        // Save authentication data to shared preferences
        final appPref = sl<AppPref>();
        await appPref.setToken(response.token);
        await appPref.setUserId(response.userId);


        // Best Practice: Update API client with new token
        sl<ApiClient>().setAuthToken(response.token);

        emit(
          state.copyWith(
            loginStatus: StateStatus.success,
            loginEntity: response,
          ),
        );
        if (context.mounted) {
          context.pushReplacementNamed(AppRoutes.examples);
        }
      },
    );
  }

  /// Logout user and reset auth state
  Future<void> logout() async {
    try {
      // Clear authentication data from shared preferences
      final appPref = sl<AppPref>();

      // Remove auth token from API client
      sl<ApiClient>().removeAuthToken();

      // Reset state to initial (clears all auth data)
      emit(const AuthState());
    } catch (e) {
      // Even if error occurs, reset state
      emit(const AuthState());
    }
  }
}
