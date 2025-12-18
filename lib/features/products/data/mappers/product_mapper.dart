import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductMapper {
  static ProductEntity toEntity(ProductModel model) {
    return ProductEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      category: model.category,
      price: model.price,
      discountPercentage: model.discountPercentage,
      rating: model.rating,
      stock: model.stock,
      tags: model.tags,
      brand: model.brand,
      sku: model.sku,
      thumbnail: model.thumbnail,
      images: model.images,
    );
  }
}
