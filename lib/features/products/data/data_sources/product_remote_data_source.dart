import '../models/product_model.dart';
import '../models/products_response.dart';

abstract class ProductRemoteDataSource {
  Future<ProductsResponse> getProducts({int? skip, int? limit});

  Future<ProductModel> getProductById(int id);

  Future<ProductsResponse> getProductsByCategory(String category);

  Future<ProductsResponse> searchProducts(String query);
}
