import '../../domain/entities/clean_feature_entity.dart';

/// Data model - Example for Clean Architecture
/// Extends CleanFeatureEntity and adds JSON serialization
/// This is a sample model for understanding Clean Architecture structure
class CleanFeatureModel extends CleanFeatureEntity {
  const CleanFeatureModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    super.updatedAt,
    super.isCompleted,
  });

  /// Create CleanFeatureModel from JSON
  factory CleanFeatureModel.fromJson(Map<String, dynamic> json) {
    return CleanFeatureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert CleanFeatureModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Convert CleanFeatureModel to CleanFeatureEntity
  CleanFeatureEntity toEntity() {
    return CleanFeatureEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isCompleted: isCompleted,
    );
  }
}
