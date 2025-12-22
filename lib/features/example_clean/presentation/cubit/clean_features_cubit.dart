import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/clean_feature_entity.dart';
import '../../domain/use_cases/clean_create_feature_use_case.dart';
import '../../domain/use_cases/clean_get_features_use_case.dart';
import '../../domain/use_cases/create_feature_params.dart';
import 'clean_features_state.dart';

/// Cubit for managing Clean Features state - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample cubit for understanding Clean Architecture structure
class CleanFeaturesCubit extends Cubit<CleanFeaturesState> {
  final CleanGetFeaturesUseCase getFeaturesUseCase;
  final CleanCreateFeatureUseCase createFeatureUseCase;

  CleanFeaturesCubit({
    required this.getFeaturesUseCase,
    required this.createFeatureUseCase,
  }) : super(const CleanFeaturesState()) {
    loadFeatures();
  }

  /// GET: Load all features
  Future<void> loadFeatures() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getFeaturesUseCase.call();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (features) {
        emit(
          state.copyWith(
            features: features,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// POST: Create a new feature with 2 params (title, content)
  Future<void> createFeature({
    required String title,
    required String content,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Pass params to use case
    final result = await createFeatureUseCase.call(
      CreateFeatureParams(title: title, content: content),
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (feature) {
        final updatedFeatures = [feature, ...state.features];
        emit(
          state.copyWith(
            features: updatedFeatures,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
