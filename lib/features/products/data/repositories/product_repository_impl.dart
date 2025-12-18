import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/products_result.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorMsg, ProductsResult>> getProducts({
    int? skip,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        skip: skip,
        limit: limit,
      );
      final entities = response.products
          .map((model) => ProductMapper.toEntity(model))
          .toList();
      return Right(
        ProductsResult(
          products: entities,
          total: response.total,
          skip: response.skip,
          limit: response.limit,
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, ProductEntity>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Right(ProductMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, List<ProductEntity>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(category);
      final entities = response.products
          .map((model) => ProductMapper.toEntity(model))
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    try {
      final response = await remoteDataSource.searchProducts(query);
      final entities = response.products
          .map((model) => ProductMapper.toEntity(model))
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
