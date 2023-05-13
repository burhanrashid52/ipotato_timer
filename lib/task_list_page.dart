import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task.dart';
import 'package:ipotato_timer/data/data_source.dart';
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
            return const Center(
              child: CircularProgressIndicator(),
            );
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (task.isFinished) ...[
              const Text('FINISHED'),
            ] else ...[
              TaskTimerToggle(task: task),
            ],
            Text(task.title)
          ],
        ),
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
