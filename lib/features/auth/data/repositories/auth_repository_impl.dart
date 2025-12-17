import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../mappers/login_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorMsg, LoginEntity>> loginUser({
    required LoginParams params,
  }) async {
    try {
      final response = await remoteDataSource.login(
        params.email,
        params.password,
      );
      final entity = LoginMapper.toEntity(response);
      return Right(entity);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, bool>> isAuthenticated() async {
    try {
      // Implement authentication check (e.g., check if token exists and is valid)
      // For now, this is a placeholder
      return const Right(false);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
