import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/main.dart';
import 'package:ipotato_timer/widget/countdown_timer.dart';

import 'extension.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Potato Timer',
          style: context.theme.textTheme.headlineLarge,
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: repository.watchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return Padding(
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
          } else {
            return const SplashScreen();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTaskPage.launchDialog(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
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
    return Card(
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
              onPressed: () => repository.stopTask(task.id),
            ),
          ],
        ],
      ),
    );
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
            repository.markAsFinished(
              task.id,
              task.duration,
            );
          },
        ),
        const SizedBox(width: 8.0),
        if (task.isRunning) ...[
          _buildIconButton(
            context,
            Icons.pause,
            () => repository.pauseTask(task.id),
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
          () => repository.stopTask(task.id),
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
          'assets/sound_wave.png',
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
          'assets/sound_wave.png',
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}
