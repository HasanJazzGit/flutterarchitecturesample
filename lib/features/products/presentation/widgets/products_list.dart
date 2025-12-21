import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import 'product_card.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {

        if (state.isLoading ) {
       return AppShimmerGrid();
        }

        if (state.errorMessage != null && state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProductsCubit>().refreshProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.products.isEmpty) {
          return Center(
            child: Text(
              'No products found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<ProductsCubit>().refreshProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: state.products.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.products.length) {
                // Load more indicator
                if (state.hasMore && !state.isLoading) {
                  context.read<ProductsCubit>().loadMoreProducts();
                }
                return const Center(child: CircularProgressIndicator());
              }

              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  // Navigate to product details if needed
                },
              );
            },
          ),
        );
      },
    );
  }
}
