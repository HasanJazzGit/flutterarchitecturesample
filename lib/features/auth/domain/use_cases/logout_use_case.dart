import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/auth_repository.dart';

/// Use case for logging out a user
class LogoutUseCase extends UseCaseVoidNoParams {
  final AuthRepository authRepository;

  LogoutUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, void>> call() async {
    return await authRepository.logout();
  }
}
