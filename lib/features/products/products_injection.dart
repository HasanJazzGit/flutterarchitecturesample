import '../../core/di/dependency_injection.dart';
import '../../core/database/app_database.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/connectivity_service.dart';
import 'data/data_sources/product_local_data_source.dart';
import 'data/data_sources/product_local_data_source_impl.dart';
import 'data/data_sources/product_remote_data_source.dart';
import 'data/data_sources/product_remote_data_source_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/use_cases/get_products_use_case.dart';
import 'presentation/cubit/products_cubit.dart';

/// Initialize products feature dependencies
void initProductsInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl<AppDatabase>()),
  );

  // Register Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(productRepository: sl<ProductRepository>()),
  );

  // Register Cubits (Factory - creates new instance each time)
  sl.registerFactory<ProductsCubit>(
    () => ProductsCubit(getProductsUseCase: sl<GetProductsUseCase>()),
  );
}
