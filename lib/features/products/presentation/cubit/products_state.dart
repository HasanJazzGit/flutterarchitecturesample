import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

class ProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;
  final int total;
  final int skip;
  final int limit;
  final bool hasMore;

  const ProductsState({
    required this.products,
    required this.isLoading,
    this.errorMessage,
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasMore,
  });

  factory ProductsState.initial() {
    return const ProductsState(
      products: [],
      isLoading: false,
      errorMessage: null,
      total: 0,
      skip: 0,
      limit: 30,
      hasMore: true,
    );
  }

  ProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
    int? total,
    int? skip,
    int? limit,
    bool? hasMore,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoading,
    errorMessage,
    total,
    skip,
    limit,
    hasMore,
  ];
}
