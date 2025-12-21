import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/clean_feature_local_data_source.dart';
import 'data/data_sources/clean_feature_local_data_source_impl.dart';
import 'data/data_sources/clean_feature_remote_data_source.dart';
import 'data/data_sources/clean_feature_remote_data_source_impl.dart';
import 'data/repositories/clean_feature_repository_impl.dart';
import 'domain/repositories/clean_feature_repository.dart';
import 'domain/use_cases/clean_create_feature_use_case.dart';
import 'domain/use_cases/clean_get_features_use_case.dart';
import 'presentation/cubit/clean_features_cubit.dart';

/// Initialize example_clean feature dependencies
/// Simple example: GET list and POST create
/// This is a sample injection file for understanding Clean Architecture structure
void initExampleCleanInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<CleanFeatureRemoteDataSource>(
    () => CleanFeatureRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<CleanFeatureLocalDataSource>(
    () => CleanFeatureLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<CleanFeatureRepository>(
    () => CleanFeatureRepositoryImpl(
      remoteDataSource: sl<CleanFeatureRemoteDataSource>(),
      localDataSource: sl<CleanFeatureLocalDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<CleanGetFeaturesUseCase>(
    () => CleanGetFeaturesUseCase(
      featureRepository: sl<CleanFeatureRepository>(),
    ),
  );

  sl.registerLazySingleton<CleanCreateFeatureUseCase>(
    () => CleanCreateFeatureUseCase(
      featureRepository: sl<CleanFeatureRepository>(),
    ),
  );

  // Register Cubit (Factory - creates new instance each time)
  sl.registerFactory<CleanFeaturesCubit>(
    () => CleanFeaturesCubit(
      getFeaturesUseCase: sl<CleanGetFeaturesUseCase>(),
      createFeatureUseCase: sl<CleanCreateFeatureUseCase>(),
    ),
  );
}
