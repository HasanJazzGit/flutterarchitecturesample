import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/clean_feature_entity.dart';

part 'clean_features_state.freezed.dart';

/// State class for Clean Features - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample state for understanding Clean Architecture structure
@freezed
class CleanFeaturesState with _$CleanFeaturesState {
  const factory CleanFeaturesState({
    @Default([]) List<CleanFeatureEntity> features,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CleanFeaturesState;

  factory CleanFeaturesState.initial() {
    return const CleanFeaturesState(
      features: [],
      isLoading: false,
      errorMessage: null,
    );
  }
}
