import '../../domain/entities/login_entity.dart';
import '../models/login_response.dart';

class LoginMapper {
  static LoginEntity toEntity(LoginResponse response) {
    return LoginEntity(
      token: response.token,
      userId: response.userId,
      email: response.email,
      refreshToken: response.refreshToken,
      expiresAt: response.expiresIn != null
          ? DateTime.now().add(Duration(seconds: response.expiresIn!))
          : null,
    );
  }
}

