import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/products_cubit.dart';
import '../widgets/products_list.dart';

/// Products page displaying list of products with offline support
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Products'), centerTitle: true),
        body: const ProductsList(),
      ),
    );
  }
}
