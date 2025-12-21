import '../../../../core/network/api_client.dart';
import '../../domain/use_cases/create_feature_params.dart';
import '../models/clean_feature_model.dart';
import 'clean_feature_remote_data_source.dart';

/// Remote data source implementation - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample implementation for understanding Clean Architecture structure
class CleanFeatureRemoteDataSourceImpl implements CleanFeatureRemoteDataSource {
  final ApiClient apiClient;

  CleanFeatureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CleanFeatureModel>> getFeatures() async {
    try {
      // Example: GET /features
      // final response = await apiClient.get('/features');
      // return (response as List).map((json) => CleanFeatureModel.fromJson(json)).toList();

      // Mock data for example
      return [];
    } catch (e) {
      throw Exception('Failed to get features: ${e.toString()}');
    }
  }

  @override
  Future<CleanFeatureModel> createFeature(CreateFeatureParams params) async {
    try {
      // Example: POST /features
      // Params object is passed through from UseCase → Repository → DataSource
      // final response = await apiClient.post('/features', data: {
      //   'title': params.title,
      //   'content': params.content,
      // });
      // return CleanFeatureModel.fromJson(response);

      // Mock data for example
      return CleanFeatureModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: params.title,
        content: params.content,
        createdAt: DateTime.now(),
        isCompleted: false,
      );
    } catch (e) {
      throw Exception('Failed to create feature: ${e.toString()}');
    }
  }
}
