import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/error_widget.dart' as core;
import '../../viewmodel/task_cubit.dart';
import '../../viewmodel/task_state.dart';
import 'task_card.dart';

/// Widget displaying list of tasks (MVVM - View layer)
class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state.isLoading && state.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null && state.tasks.isEmpty) {
          return core.ErrorWidget(
            message: state.errorMessage!,
            onRetry: () => context.read<TaskCubit>().loadTasks(),
          );
        }

        if (state.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_outlined,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to create your first task',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<TaskCubit>().loadTasks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskCard(task: task),
              );
            },
          ),
        );
      },
    );
  }
}
