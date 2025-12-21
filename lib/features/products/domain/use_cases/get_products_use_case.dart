import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/product_list.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase
    implements UseCase<ProductListEntity, GetProductsParams> {
  final ProductRepository productRepository;

  GetProductsUseCase({required this.productRepository});

  @override
  Future<Either<ErrorMsg, ProductListEntity>> call(
    GetProductsParams params,
  ) async {
    return await productRepository.getProducts(params: params);
  }
}

class GetProductsParams {
  final int? skip;
  final int? limit;

  GetProductsParams({this.skip, this.limit});
}
