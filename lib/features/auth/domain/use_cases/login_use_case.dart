import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, LoginEntity>> call(LoginParams params) async {
    return await authRepository.loginUser(params: params);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
