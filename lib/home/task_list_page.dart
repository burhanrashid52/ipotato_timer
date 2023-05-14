import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task/add_task.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/home/widgets/countdown_timer.dart';
import 'package:ipotato_timer/main.dart';
import 'package:ipotato_timer/util/app_constants.dart';
import 'package:ipotato_timer/util/app_extension.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: repository.watchTasks(),
      builder: (context, snapshot) {
        List<Task> tasks = [];
        Widget body = const Center(child: CircularProgressIndicator());

        if (snapshot.hasData) {
          tasks = snapshot.data!;
          body = Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(task: task);
              },
              separatorBuilder: (_, int index) => const SizedBox(height: 20),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Potato Timer',
              style: context.theme.textTheme.headlineLarge?.copyWith(
                color: context.theme.colorScheme.onSecondary,
              ),
            ),
          ),
          body: body,
          floatingActionButton: AddTaskFloatingButton(
            showHint: tasks.isEmpty,
          ),
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final child = Card(
      color: context.theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (task.isFinished) ...[
                  const TaskFinished(),
                ] else ...[
                  TaskTimerToggle(task: task),
                ],
                const SizedBox(height: 16.0),
                Text(
                  task.title,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                if (task.description != null &&
                    task.description!.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    task.description!,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (task.isFinished) ...[
            const SizedBox(height: 4.0),
            MaterialButton(
              color: context.theme.colorScheme.onTertiaryContainer,
              child: const Text('MARK COMPLETE'),
              onPressed: () => repository.deleteTask(task.id),
            ),
          ],
        ],
      ),
    );
    if (task.isFinished) {
      return Dismissible(
        key: ValueKey('swipe_task_${task.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            repository.deleteTask(task.id);
          }
        },
        background: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(31.0),
            child: Icon(
              Icons.delete,
              size: 32,
              color: Colors.red,
            ),
          ),
        ),
        child: child,
      );
    }
    return child;
  }
}

class TaskTimerToggle extends StatelessWidget {
  const TaskTimerToggle({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        CountdownTimer(
          key: ValueKey(
            "${task.id}-${task.elapsedDuration.inSeconds}-${task.isRunning}",
          ),
          duration: task.duration,
          elapsedTime: task.totalElapsed,
          stop: !task.isRunning,
          onFinished: () {
            repository
                .markAsFinished(task.id, task.duration)
                .then((_) => soundManager.playBell());
          },
        ),
        const SizedBox(width: 8.0),
        if (task.isRunning) ...[
          _buildIconButton(
            context,
            Icons.pause,
            () => repository.pauseTask(task.id).onError(
              (error, _) {
                context.showSnackBar(error.toString());
                return Duration.zero;
              },
            ),
          ),
        ] else ...[
          _buildIconButton(
            context,
            Icons.play_arrow,
            () => repository.startTask(task.id),
          ),
        ],
        _buildIconButton(
          context,
          Icons.stop,
          () => repository.deleteTask(task.id),
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData iconData,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconButton(
          color: context.theme.colorScheme.surface,
          padding: EdgeInsets.zero,
          icon: Icon(iconData),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class TaskFinished extends StatelessWidget {
  const TaskFinished({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          Assets.soundWaveImage,
          width: 24,
          height: 24,
        ),
        Text(
          'FINISHED',
          style: context.theme.textTheme.headlineLarge?.copyWith(
            color: context.theme.colorScheme.primary,
          ),
        ),
        Image.asset(
          Assets.soundWaveImage,
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}

class AddTaskFloatingButton extends StatelessWidget {
  const AddTaskFloatingButton({
    super.key,
    this.showHint = false,
  });

  final bool showHint;

  @override
  Widget build(BuildContext context) {
    final child = FloatingActionButton.large(
      onPressed: () => AddTaskPage.launchDialog(context),
      tooltip: 'Add task',
      child: const Icon(
        Icons.add_circle_outline,
        size: 48,
      ),
    );
    if (showHint) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: child,
          ),
          Positioned(
            right: 16,
            bottom: 108,
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    'No timers active.\nPress here to start a new one',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 32.0),
                  Image.asset(
                    Assets.arrowDownImage,
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }
}
