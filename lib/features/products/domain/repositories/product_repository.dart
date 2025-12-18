import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/product_entity.dart';
import '../entities/products_result.dart';

abstract class ProductRepository {
  /// Get all products with pagination
  Future<Either<ErrorMsg, ProductsResult>> getProducts({int? skip, int? limit});

  /// Get product by ID
  Future<Either<ErrorMsg, ProductEntity>> getProductById(int id);

  /// Get products by category
  Future<Either<ErrorMsg, List<ProductEntity>>> getProductsByCategory(
    String category,
  );

  /// Search products
  Future<Either<ErrorMsg, List<ProductEntity>>> searchProducts(String query);
}
