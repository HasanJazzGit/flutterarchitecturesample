import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/models/task_model.dart';
import 'task_local_data_source.dart';

/// Implementation of local data source using SharedPreferences - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample implementation for understanding MVVM structure
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'mvvm_tasks';

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final jsonString = sharedPreferences.getString(_key);
      if (jsonString == null) return [];

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks from local storage: $e');
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    try {
      final tasks = await getTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);

      if (index >= 0) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }

      await saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to save task to local storage: $e');
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final jsonString = jsonEncode(
        tasks.map((task) => task.toJson()).toList(),
      );
      await sharedPreferences.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Failed to save tasks to local storage: $e');
    }
  }
}
