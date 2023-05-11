import 'package:flutter/material.dart';
import 'package:ipotato_timer/main.dart';

import 'data/local_data_source.dart';

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
                        Task(title: textController.text),
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
