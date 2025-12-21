import 'package:dartz/dartz.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/app_pref.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../mappers/login_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AppPref _appPref;

  AuthRepositoryImpl(this.remoteDataSource, {AppPref? appPref})
    : _appPref = appPref ?? sl<AppPref>();

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
      // Call API logout if needed
      await remoteDataSource.logout();

      // Clear local authentication data
      await _appPref.logout();

      return const Right(null);
    } on ApiException catch (e) {
      // Even if API call fails, clear local data
      await _appPref.logout();
      return Left(e.message);
    } catch (e) {
      // Even if error occurs, clear local data
      await _appPref.logout();
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, bool>> isAuthenticated() async {
    try {
      // Check authentication status from shared preferences
      // Best Practice: Check both token and session validity
      final isAuth = _appPref.isAuthenticated();
      final isSessionValid = _appPref.isSessionValid();

      return Right(isAuth && isSessionValid);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
