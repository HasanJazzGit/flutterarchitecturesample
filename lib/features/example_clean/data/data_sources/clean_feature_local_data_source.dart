import '../models/clean_feature_model.dart';

/// Local data source interface - Example for Clean Architecture
/// Abstract interface for local preference operations
/// This is a sample local data source for understanding Clean Architecture structure
abstract class CleanFeatureLocalDataSource {
  /// Get all features from local preference
  Future<List<CleanFeatureModel>> getFeatures();

  /// Get a single feature by ID from local preference
  Future<CleanFeatureModel?> getFeatureById(String id);

  /// Save a feature to local preference
  Future<void> saveFeature(CleanFeatureModel feature);

  /// Save multiple features to local preference
  Future<void> saveFeatures(List<CleanFeatureModel> features);
}
