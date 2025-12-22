import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/task_repository_impl.dart';
import '../model/models/task_model.dart';
import 'task_state.dart';

/// Cubit for managing Tasks - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample cubit for understanding MVVM structure
class TaskCubit extends Cubit<TaskState> {
  final TaskRepositoryImpl taskRepository;

  TaskCubit({required this.taskRepository}) : super(const TaskState()) {
    loadTasks();
  }

  /// GET: Load all tasks
  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await taskRepository.getTasks();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (tasks) {
        emit(
          state.copyWith(tasks: tasks, isLoading: false, errorMessage: null),
        );
      },
    );
  }

  /// POST: Create a new task with 2 params (title, description)
  Future<void> createTask({
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // POST: Pass params to repository
    final result = await taskRepository.createTask(
      title: title,
      description: description,
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (task) {
        final updatedTasks = [task, ...state.tasks];
        emit(
          state.copyWith(
            tasks: updatedTasks,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
