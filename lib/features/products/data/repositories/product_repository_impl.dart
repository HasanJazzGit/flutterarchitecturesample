import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/utils/connectivity_service.dart';
import '../../domain/entities/product_list.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<Either<ErrorMsg, ProductListEntity>> getProducts({
    required GetProductsParams params,
  }) async {
    // Check internet connectivity
    final hasInternet = await connectivityService.hasInternetConnection();

    if (hasInternet) {
      // Try to fetch from remote API
      try {
        final response = await remoteDataSource.getProducts(params: params);

        // Save to local database for offline access
        // Clear first if it's a refresh (skip == 0)
        try {
          await localDataSource.saveProducts(
            response,
            clearFirst: params.skip == null || params.skip == 0,
          );
        } catch (e) {
          // Log error but don't fail the request
          print('Failed to save products to local database: $e');
        }

        // Convert to entities and return
        final entities = response.products
            .map((model) => ProductMapper.toEntity(model))
            .toList();
        return Right(
          ProductListEntity(
            products: entities,
            total: response.total,
            skip: response.skip,
            limit: response.limit,
          ),
        );
      } catch (e) {
        // If remote fails, try local database
        return await _getProductsFromLocal(params);
      }
    } else {
      // No internet - get from local database
      return await _getProductsFromLocal(params);
    }
  }

  /// Get products from local database
  Future<Either<ErrorMsg, ProductListEntity>> _getProductsFromLocal(
    GetProductsParams params,
  ) async {
    try {
      final response = await localDataSource.getProducts(
        skip: params.skip,
        limit: params.limit,
      );

      if (response.products.isEmpty) {
        return const Left(
          'No products available offline. Please connect to the internet.',
        );
      }

      final entities = response.products
          .map((model) => ProductMapper.toEntity(model))
          .toList();

      return Right(
        ProductListEntity(
          products: entities,
          total: response.total,
          skip: response.skip,
          limit: response.limit,
        ),
      );
    } catch (e) {
      return Left('Failed to load products from local preference: $e');
    }
  }
}
