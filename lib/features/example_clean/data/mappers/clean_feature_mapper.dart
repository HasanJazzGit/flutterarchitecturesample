import '../../domain/entities/clean_feature_entity.dart';
import '../models/clean_feature_model.dart';

/// Mapper - Example for Clean Architecture
/// Converts between Model and Entity
/// This is a sample mapper for understanding Clean Architecture structure
class CleanFeatureMapper {
  /// Convert CleanFeatureModel to CleanFeatureEntity
  static CleanFeatureEntity toEntity(CleanFeatureModel model) {
    return CleanFeatureEntity(
      id: model.id,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isCompleted: model.isCompleted,
    );
  }

  /// Convert CleanFeatureEntity to CleanFeatureModel
  static CleanFeatureModel toModel(CleanFeatureEntity entity) {
    return CleanFeatureModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isCompleted: entity.isCompleted,
    );
  }
}
