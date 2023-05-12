import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task.dart';
import 'package:ipotato_timer/data/drift_tables.dart';
import 'package:ipotato_timer/data/local_data_source.dart';
import 'package:ipotato_timer/data/task_repository.dart';

final repository = TaskRepository(
  LocalDataSource(
    AppDatabase(),
  ),
);

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
        primarySwatch: Colors.blue,
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
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      repository.startTask(task.id);
                    },
                  ),
                  title: Text(task.title),
                  subtitle: Text(
                    "${task.isRunning ? "Running" : "Pause"} - ${task.isFinished ? "Finish" : "Not Finish"} - Elapsed ${task.elapsedDuration.inSeconds.toString()}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () {
                      repository.pauseTask(task.id);
                    },
                  ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
