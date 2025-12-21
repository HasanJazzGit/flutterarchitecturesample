import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/clean_feature_entity.dart';
import '../use_cases/create_feature_params.dart';

/// Repository interface - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample repository for understanding Clean Architecture structure
abstract class CleanFeatureRepository {
  /// Get all features (GET /features)
  Future<Either<ErrorMsg, List<CleanFeatureEntity>>> getFeatures();

  /// Create a new feature (POST /features)
  /// Passes CreateFeatureParams through to data source
  Future<Either<ErrorMsg, CleanFeatureEntity>> createFeature(
    CreateFeatureParams params,
  );
}
