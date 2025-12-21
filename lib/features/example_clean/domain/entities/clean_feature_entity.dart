import 'package:equatable/equatable.dart';

/// Domain entity - Example for Clean Architecture
/// Pure Dart class with no framework dependencies
/// This is a sample entity for understanding Clean Architecture structure
class CleanFeatureEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;

  const CleanFeatureEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
  });

  /// Create a copy with updated fields
  CleanFeatureEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return CleanFeatureEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    isCompleted,
  ];
}
