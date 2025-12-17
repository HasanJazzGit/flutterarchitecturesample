import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/auth_repository.dart';

/// Use case for checking if user is authenticated
class IsAuthenticatedUseCase extends UseCaseNoParams<bool> {
  final AuthRepository authRepository;

  IsAuthenticatedUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, bool>> call() async {
    return await authRepository.isAuthenticated();
  }
}
