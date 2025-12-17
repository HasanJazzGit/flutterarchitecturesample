import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/login_entity.dart';
import 'state_status.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(StateStatus.idle) StateStatus loginStatus,
    @Default(StateStatus.idle) StateStatus verifyOtpState,
    LoginEntity? loginEntity,
  }) = _AuthState;
}
