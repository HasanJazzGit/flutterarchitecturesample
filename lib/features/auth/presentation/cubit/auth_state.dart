import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fluttersampleachitecture/features/auth/domain/entities/login_entity.dart';
import '../../../../core/enums/state_status.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(StateStatus.idle) StateStatus loginStatus,
    @Default(StateStatus.idle) StateStatus verifyOtpState,
    LoginEntity? loginEntity,
    @Default(false) bool rememberMe,
  }) = _AuthState;
}
