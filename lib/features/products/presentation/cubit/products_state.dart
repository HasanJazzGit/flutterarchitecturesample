import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState({
    @Default([]) List<ProductEntity> products,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(30) int limit,
    @Default(true) bool hasMore,
  }) = _ProductsState;

  const ProductsState._();
}
