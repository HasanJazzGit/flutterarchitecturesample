import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../domain/entities/clean_feature_entity.dart';
import '../../domain/repositories/clean_feature_repository.dart';
import '../../domain/use_cases/create_feature_params.dart';
import '../data_sources/clean_feature_local_data_source.dart';
import '../data_sources/clean_feature_remote_data_source.dart';
import '../mappers/clean_feature_mapper.dart';

/// Repository implementation - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample repository for understanding Clean Architecture structure
class CleanFeatureRepositoryImpl implements CleanFeatureRepository {
  final CleanFeatureRemoteDataSource remoteDataSource;
  final CleanFeatureLocalDataSource localDataSource;

  CleanFeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<ErrorMsg, List<CleanFeatureEntity>>> getFeatures() async {
    try {
      // GET: Try remote first, fallback to local
      final remoteFeatures = await remoteDataSource.getFeatures();

      // Save to local storage
      await localDataSource.saveFeatures(remoteFeatures);

      // Convert to entities
      final entities = remoteFeatures
          .map((model) => CleanFeatureMapper.toEntity(model))
          .toList();
      return Right(entities);
    } catch (e) {
      // Fallback to local storage
      try {
        final localFeatures = await localDataSource.getFeatures();
        final entities = localFeatures
            .map((model) => CleanFeatureMapper.toEntity(model))
            .toList();
        return Right(entities);
      } catch (localError) {
        return Left('Failed to load features: ${localError.toString()}');
      }
    }
  }

  @override
  Future<Either<ErrorMsg, CleanFeatureEntity>> createFeature(
    CreateFeatureParams params,
  ) async {
    try {
      // POST: Pass params object through to data source
      final feature = await remoteDataSource.createFeature(params);

      // Save to local storage
      await localDataSource.saveFeature(feature);

      return Right(CleanFeatureMapper.toEntity(feature));
    } catch (e) {
      return Left('Failed to create feature: ${e.toString()}');
    }
  }
}
