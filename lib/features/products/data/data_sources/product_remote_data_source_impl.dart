import 'package:fluttersampleachitecture/features/products/domain/use_cases/get_products_use_case.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_urls.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProductsResponse> getProducts({required GetProductsParams params}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (params.skip != null) queryParams['skip'] = params.skip;
      if (params.limit != null) queryParams['limit'] = params.limit;

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

}
