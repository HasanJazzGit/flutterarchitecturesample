import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/product_entity.dart';
import '../entities/product_list.dart';
import '../use_cases/get_products_use_case.dart';

abstract class ProductRepository {
  /// Get all products with pagination
  Future<Either<ErrorMsg, ProductListEntity>> getProducts({
    required GetProductsParams params,
  });
}
