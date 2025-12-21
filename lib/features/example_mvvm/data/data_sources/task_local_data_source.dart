import '../../model/models/task_model.dart';

/// Abstract interface for local data source - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample local data source for understanding MVVM structure
abstract class TaskLocalDataSource {
  /// Get all tasks from local storage
  Future<List<TaskModel>> getTasks();

  /// Save a task to local storage
  Future<void> saveTask(TaskModel task);

  /// Save multiple tasks to local storage
  Future<void> saveTasks(List<TaskModel> tasks);
}
