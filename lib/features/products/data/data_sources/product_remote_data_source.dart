import 'package:fluttersampleachitecture/features/products/domain/use_cases/get_products_use_case.dart';

import '../models/product_model.dart';
import '../models/products_response.dart';

abstract class ProductRemoteDataSource {
  Future<ProductsResponse> getProducts({required GetProductsParams params});


}
