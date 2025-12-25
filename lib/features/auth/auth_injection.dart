import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'data/data_sources/auth_remote_data_source_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/use_cases/login_use_case.dart';
import 'presentation/cubit/auth_cubit.dart';

/// Initialize authentication feature dependencies
void initAuthInjector() {
  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(sl<AuthRemoteDataSource>(), appPref: sl<AppPref>()),
  );

  // Register Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepository: sl<AuthRepository>()),
  );

  // Register Cubits
  // Lazy Singleton: Same instance shared across all auth screens (login, OTP, password recovery, logout)
  // This ensures state persists between navigation (e.g., email from login available in OTP screen)
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));

}
