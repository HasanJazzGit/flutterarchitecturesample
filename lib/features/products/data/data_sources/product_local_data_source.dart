import '../models/products_response.dart';

/// Abstract interface for local product data source
abstract class ProductLocalDataSource {
  /// Save products to local database
  Future<void> saveProducts(
    ProductsResponse response, {
    bool clearFirst = false,
  });

  /// Get products from local database
  Future<ProductsResponse> getProducts({int? skip, int? limit});

  /// Clear all products from local database
  Future<void> clearProducts();

  /// Get total count of products in database
  Future<int> getProductsCount();
}
