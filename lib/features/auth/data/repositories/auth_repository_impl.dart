import '../../../../core/functional/functional_export.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/preference/app_pref.dart';
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
       params: params
      );
      final entity = LoginMapper.toEntity(response);
      return Right(entity);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

}
