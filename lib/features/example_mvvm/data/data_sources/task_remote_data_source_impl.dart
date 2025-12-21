import '../../../../core/network/api_client.dart';
import '../../model/models/task_model.dart';
import 'task_remote_data_source.dart';

/// Remote data source implementation - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample implementation for understanding MVVM structure
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient apiClient;

  TaskRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      // Example: GET /tasks
      // final response = await apiClient.get('/tasks');
      // return (response as List).map((json) => TaskModel.fromJson(json)).toList();

      // Mock data for example
      return [];
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  @override
  Future<TaskModel> createTask({
    required String title,
    required String description,
  }) async {
    try {
      // Example: POST /tasks
      // final response = await apiClient.post('/tasks', data: {
      //   'title': title,
      //   'description': description,
      // });
      // return TaskModel.fromJson(response);

      // Mock data for example
      return TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isCompleted: false,
      );
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }
}
