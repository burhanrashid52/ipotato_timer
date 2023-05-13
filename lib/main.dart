import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/widget/countdown_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPotato Timer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iPotato Timer'),
      ),
      body: StreamBuilder<List<Task>>(
        stream: repository.watchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (task.isFinished) ...[
                          const Expanded(
                            child: Text('FINISHED'),
                          ),
                        ] else ...[
                          Expanded(
                            child: CountdownTimer(
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
                          ),
                        ],
                        if (task.isRunning) ...[
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: () {
                              repository.pauseTask(task.id);
                            },
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              repository.startTask(task.id);
                            },
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () {
                            repository.stopTask(task.id);
                          },
                        )
                      ],
                    ),
                    Text(task.title)
                  ],
                );
              },
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
