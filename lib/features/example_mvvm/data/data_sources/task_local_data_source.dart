import '../../model/models/task_model.dart';

/// Abstract interface for local data source - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample local data source for understanding MVVM structure
abstract class TaskLocalDataSource {
  /// Get all tasks from local preference
  Future<List<TaskModel>> getTasks();

  /// Save a task to local preference
  Future<void> saveTask(TaskModel task);

  /// Save multiple tasks to local preference
  Future<void> saveTasks(List<TaskModel> tasks);
}
