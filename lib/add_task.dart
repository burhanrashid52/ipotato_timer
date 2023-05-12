import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:ipotato_timer/main.dart';

import 'data/local_data_source.dart';

//1. Write a test to insert item at local data source
//2. Write a test for local data source to check if its stored in database
class AddTaskPage extends StatelessWidget {
  AddTaskPage({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Column(
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          ListenableBuilder(
            listenable: textController,
            builder: (context, _) => ElevatedButton(
              onPressed: textController.text.isEmpty
                  ? null
                  : () {
                      localDataSource.addTask(
                        Task(
                          title: textController.text,
                          duration: const Duration(minutes: 1),
                          startedAt: clock.now(),
                        ),
                      );
                      Navigator.pop(context);
                    },
              child: const Text('Add'),
            ),
          )
        ],
      ),
    );
  }
}
