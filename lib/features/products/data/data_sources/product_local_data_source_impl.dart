import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';
import 'product_local_data_source.dart';

/// Implementation of local product data source using Drift
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSourceImpl(this.database);

  @override
  Future<void> saveProducts(
    ProductsResponse response, {
    bool clearFirst = false,
  }) async {
    try {
      // Clear existing products before saving new ones (for refresh)
      if (clearFirst) {
        await clearProducts();
      }

      // Convert products to database entities
      final productsCompanions = response.products.map((product) {
        return ProductsCompanion.insert(
          id: Value(product.id),
          title: product.title,
          description: product.description,
          category: product.category,
          price: product.price,
          discountPercentage: product.discountPercentage,
          rating: product.rating,
          stock: product.stock,
          tags: jsonEncode(product.tags),
          brand: Value(product.brand),
          sku: product.sku,
          thumbnail: product.thumbnail,
          images: jsonEncode(product.images),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
      }).toList();

      // Insert products into database
      await database.batch((batch) {
        batch.insertAll(database.products, productsCompanions);
      });
    } catch (e) {
      throw Exception('Failed to save products to database: $e');
    }
  }

  @override
  Future<ProductsResponse> getProducts({int? skip, int? limit}) async {
    try {
      final query = database.select(database.products)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);

      if (skip != null) {
        query.limit(limit ?? 30, offset: skip);
      } else if (limit != null) {
        query.limit(limit);
      }

      final dbProducts = await query.get();

      // Convert database entities to models
      final products = dbProducts.map((dbProduct) {
        return ProductModel(
          id: dbProduct.id,
          title: dbProduct.title,
          description: dbProduct.description,
          category: dbProduct.category,
          price: dbProduct.price,
          discountPercentage: dbProduct.discountPercentage,
          rating: dbProduct.rating,
          stock: dbProduct.stock,
          tags: (jsonDecode(dbProduct.tags) as List)
              .map((e) => e.toString())
              .toList(),
          brand: dbProduct.brand,
          sku: dbProduct.sku,
          thumbnail: dbProduct.thumbnail,
          images: (jsonDecode(dbProduct.images) as List)
              .map((e) => e.toString())
              .toList(),
        );
      }).toList();

      final total = await getProductsCount();

      return ProductsResponse(
        products: products,
        total: total,
        skip: skip ?? 0,
        limit: limit ?? products.length,
      );
    } catch (e) {
      throw Exception('Failed to get products from database: $e');
    }
  }

  @override
  Future<void> clearProducts() async {
    try {
      await database.delete(database.products).go();
    } catch (e) {
      throw Exception('Failed to clear products from database: $e');
    }
  }

  @override
  Future<int> getProductsCount() async {
    try {
      final countExpression = database.products.id.count();
      final query = database.selectOnly(database.products)
        ..addColumns([countExpression]);

      final result = await query.getSingle();
      return result.read(countExpression) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
