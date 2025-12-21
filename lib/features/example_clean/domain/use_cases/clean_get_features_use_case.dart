import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/clean_feature_entity.dart';
import '../repositories/clean_feature_repository.dart';

/// Use case for getting all features - Example for Clean Architecture
/// Simple example: GET /features
/// This is a sample use case for understanding Clean Architecture structure
class CleanGetFeaturesUseCase
    implements UseCaseNoParams<List<CleanFeatureEntity>> {
  final CleanFeatureRepository featureRepository;

  CleanGetFeaturesUseCase({required this.featureRepository});

  @override
  Future<Either<ErrorMsg, List<CleanFeatureEntity>>> call() async {
    return await featureRepository.getFeatures();
  }
}
