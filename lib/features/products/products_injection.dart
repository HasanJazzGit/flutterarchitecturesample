import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/product_remote_data_source.dart';
import 'data/data_sources/product_remote_data_source_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/use_cases/get_products_use_case.dart';
import 'presentation/manager/products_cubit.dart';

/// Initialize products feature dependencies
void initProductsInjector() {
  // Register Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
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
