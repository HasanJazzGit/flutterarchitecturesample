import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/models/task_model.dart';

part 'task_state.freezed.dart';

/// State class for Tasks - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample state for understanding MVVM structure
@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    @Default([]) List<TaskModel> tasks,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TaskState;

  const TaskState._();
}
