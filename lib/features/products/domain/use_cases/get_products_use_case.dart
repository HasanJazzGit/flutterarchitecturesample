import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/products_result.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<ProductsResult, GetProductsParams> {
  final ProductRepository productRepository;

  GetProductsUseCase({required this.productRepository});

  @override
  Future<Either<ErrorMsg, ProductsResult>> call(
    GetProductsParams params,
  ) async {
    return await productRepository.getProducts(
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetProductsParams {
  final int? skip;
  final int? limit;

  GetProductsParams({this.skip, this.limit});
}
