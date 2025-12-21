import '../models/clean_feature_model.dart';

/// Local data source interface - Example for Clean Architecture
/// Abstract interface for local storage operations
/// This is a sample local data source for understanding Clean Architecture structure
abstract class CleanFeatureLocalDataSource {
  /// Get all features from local storage
  Future<List<CleanFeatureModel>> getFeatures();

  /// Get a single feature by ID from local storage
  Future<CleanFeatureModel?> getFeatureById(String id);

  /// Save a feature to local storage
  Future<void> saveFeature(CleanFeatureModel feature);

  /// Save multiple features to local storage
  Future<void> saveFeatures(List<CleanFeatureModel> features);
}
