import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_urls.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProductsResponse> getProducts({int? skip, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (skip != null) queryParams['skip'] = skip;
      if (limit != null) queryParams['limit'] = limit;

      final response = await apiClient.get(
        AppUrls.products,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return ProductsResponse.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.get(AppUrls.productById(id));
      return ProductModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<ProductsResponse> getProductsByCategory(String category) async {
    try {
      final response = await apiClient.get(
        AppUrls.productsByCategory(category),
      );
      return ProductsResponse.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to fetch products by category: ${e.toString()}');
    }
  }

  @override
  Future<ProductsResponse> searchProducts(String query) async {
    try {
      final response = await apiClient.get(AppUrls.searchProducts(query));
      return ProductsResponse.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to search products: ${e.toString()}');
    }
  }
}
