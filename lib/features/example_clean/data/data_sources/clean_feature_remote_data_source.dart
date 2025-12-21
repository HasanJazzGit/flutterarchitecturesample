import '../../domain/use_cases/create_feature_params.dart';
import '../models/clean_feature_model.dart';

/// Remote data source interface - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample remote data source for understanding Clean Architecture structure
abstract class CleanFeatureRemoteDataSource {
  /// GET all features from API
  Future<List<CleanFeatureModel>> getFeatures();

  /// POST create a new feature via API
  /// Receives CreateFeatureParams and passes to API
  Future<CleanFeatureModel> createFeature(CreateFeatureParams params);
}
