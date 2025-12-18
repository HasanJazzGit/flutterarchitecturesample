import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/products_result.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsCubit({required this.getProductsUseCase})
    : super(ProductsState.initial()) {
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          skip: 0,
          products: [],
        ),
      );
    } else {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }

    final result = await getProductsUseCase(
      GetProductsParams(skip: refresh ? 0 : state.skip, limit: state.limit),
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (result) {
        final newProducts = refresh
            ? result.products
            : [...state.products, ...result.products];
        final newSkip = refresh
            ? result.skip + result.products.length
            : state.skip + result.products.length;
        final hasMore = newProducts.length < result.total;

        emit(
          state.copyWith(
            products: newProducts,
            isLoading: false,
            errorMessage: null,
            skip: newSkip,
            total: result.total,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!state.hasMore || state.isLoading) return;
    await loadProducts();
  }
}
