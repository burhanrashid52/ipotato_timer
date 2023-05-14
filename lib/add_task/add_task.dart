import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:ipotato_timer/add_task/widgets/duration_selector.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/main.dart';
import 'package:ipotato_timer/util/app_extension.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  static Future<void> launchDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const Scaffold(
        backgroundColor: Colors.transparent,
        body: Dialog(
          child: AddTaskPage(),
        ),
      ),
    );
  }

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  var _title = '';
  var _description = '';
  var _duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        color: context.theme.colorScheme.surface,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add Task',
                      style: context.theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('text_field_title'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Title',
                      ),
                      onChanged: (value) => setState(() => _title = value),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('text_field_description'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Description',
                      ),
                      minLines: 10,
                      maxLines: 20,
                      onChanged: (value) =>
                          setState(() => _description = value),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Duration',
                      style: context.theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DurationSelector(
                      onDurationChanged: (value) =>
                          setState(() => _duration = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              MaterialButton(
                key: const ValueKey('btn_add_task'),
                color: context.theme.colorScheme.tertiaryContainer,
                onPressed: () {
                  final task = _buildTask();
                  final (:isValid, :errMsg) = repository.validate(task);
                  if (isValid) {
                    repository.addTask(task);
                    Navigator.pop(context);
                  } else {
                    context.showSnackBar(errMsg);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
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
