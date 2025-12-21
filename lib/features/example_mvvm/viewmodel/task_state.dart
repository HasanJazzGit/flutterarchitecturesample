import '../model/models/task_model.dart';

/// State class for Tasks - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample state for understanding MVVM structure
class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    required this.tasks,
    required this.isLoading,
    this.errorMessage,
  });

  factory TaskState.initial() {
    return const TaskState(tasks: [], isLoading: false, errorMessage: null);
  }

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
