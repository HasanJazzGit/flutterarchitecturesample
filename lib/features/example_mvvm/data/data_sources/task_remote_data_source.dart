import '../../model/models/task_model.dart';

/// Remote data source interface - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample remote data source for understanding MVVM structure
abstract class TaskRemoteDataSource {
  /// GET all tasks from API
  Future<List<TaskModel>> getTasks();

  /// POST create a new task via API
  /// Simple example with 2 params: title and description
  Future<TaskModel> createTask({
    required String title,
    required String description,
  });
}
