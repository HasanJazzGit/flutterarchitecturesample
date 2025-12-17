import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final DateTime? expiresAt;

  const LoginEntity({
    required this.token,
    required this.userId,
    required this.email,
    this.refreshToken,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [token, userId, email, refreshToken, expiresAt];
}

