import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:ipotato_timer/data/data_source.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  var _title = '';
  var _description = '';
  var _duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              key: const ValueKey('text_field_title'),
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (value) => setState(() => _title = value),
            ),
            TextFormField(
              key: const ValueKey('text_field_description'),
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) => setState(() => _description = value),
            ),
            ElevatedButton(
              onPressed: () {
                final task = _buildTask();
                final (:isValid, :errMsg) = repository.validate(task);
                if (isValid) {
                  repository.addTask(task);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errMsg),
                    ),
                  );
                }
              },
              child: const Text('Add Task'),
            )
          ],
        ),
      ),
    );
  }

  Task _buildTask() {
    return Task(
      id: 0,
      title: _title,
      description: _description,
      duration: _duration,
      startedAt: clock.now(),
    );
  }
}
