import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:ipotato_timer/data/data_source.dart';

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
                      repository.addTask(
                        Task(
                          id: 0,
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
