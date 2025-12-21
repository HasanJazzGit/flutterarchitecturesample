import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../model/models/task_model.dart';
import '../data_sources/task_local_data_source.dart';
import '../data_sources/task_remote_data_source.dart';

/// Repository implementation - Example for MVVM
/// Simple example: GET list and POST create
/// This is a sample repository for understanding MVVM structure
class TaskRepositoryImpl {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// GET: Get all tasks
  /// Tries remote first, falls back to local
  Future<Either<ErrorMsg, List<TaskModel>>> getTasks() async {
    try {
      // Try remote first
      final remoteTasks = await remoteDataSource.getTasks();

      // Save to local preference
      await localDataSource.saveTasks(remoteTasks);

      return Right(remoteTasks);
    } catch (e) {
      // Fallback to local preference
      try {
        final localTasks = await localDataSource.getTasks();
        return Right(localTasks);
      } catch (localError) {
        return Left('Failed to load tasks: ${localError.toString()}');
      }
    }
  }

  /// POST: Create a new task with 2 params (title, description)
  /// Saves to both remote and local
  Future<Either<ErrorMsg, TaskModel>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      // POST: Create via API with 2 params (title, description)
      final task = await remoteDataSource.createTask(
        title: title,
        description: description,
      );

      // Save to local preference
      await localDataSource.saveTask(task);

      return Right(task);
    } catch (e) {
      return Left('Failed to create task: ${e.toString()}');
    }
  }
}
