import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'data/data_sources/auth_remote_data_source_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/use_cases/is_authenticated_use_case.dart';
import 'domain/use_cases/login_use_case.dart';
import 'domain/use_cases/logout_use_case.dart';
import 'domain/use_cases/verify_otp_use_case.dart';
import 'presentation/manager/auth_cubit.dart';

/// Initialize authentication feature dependencies
void initAuthInjector() {
  // Register API Client (if not already registered)
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(baseUrl: ApiConfig.getBaseUrl()),
    );
  }

  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Register Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<IsAuthenticatedUseCase>(
    () => IsAuthenticatedUseCase(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(authRepository: sl<AuthRepository>()),
  );

  // Register Cubits (Factory - creates new instance each time)
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
}
