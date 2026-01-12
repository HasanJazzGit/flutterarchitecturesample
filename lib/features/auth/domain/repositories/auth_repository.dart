import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/login_entity.dart';
import '../use_cases/login_use_case.dart';

abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<ErrorMsg, LoginEntity>> loginUser({
    required LoginParams params,
  });

}
