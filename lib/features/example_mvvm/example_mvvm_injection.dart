import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/task_local_data_source.dart';
import 'data/data_sources/task_local_data_source_impl.dart';
import 'data/data_sources/task_remote_data_source.dart';
import 'data/data_sources/task_remote_data_source_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'viewmodel/task_cubit.dart';

/// Initialize example_mvvm feature dependencies
/// Simple example: GET list and POST create
/// This is a sample injection file for understanding MVVM structure
void initExampleMvvmInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Register Repository
  sl.registerLazySingleton<TaskRepositoryImpl>(
    () => TaskRepositoryImpl(
      remoteDataSource: sl<TaskRemoteDataSource>(),
      localDataSource: sl<TaskLocalDataSource>(),
    ),
  );

  // Register Cubit (Factory - creates new instance each time)
  sl.registerFactory<TaskCubit>(
    () => TaskCubit(taskRepository: sl<TaskRepositoryImpl>()),
  );
}
