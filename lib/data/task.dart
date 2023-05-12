import 'package:ipotato_timer/data/drift_tables.dart';

class Task {
  final int id;
  final String title;
  final Duration duration;
  final String? description;
  final DateTime? startedAt;
  final Duration elapsedDuration;

  factory Task.fromTable(TaskTable table) {
    return Task(
      id: table.id,
      title: table.title,
      description: table.description,
      duration: Duration(milliseconds: table.duration),
      elapsedDuration: Duration(milliseconds: table.elapsedDuration ?? 0),
      startedAt: table.startedAt > 0
          ? DateTime.fromMillisecondsSinceEpoch(table.startedAt)
          : null,
    );
  }

  Task({
    required this.id,
    required this.title,
    required this.duration,
    this.description,
    this.startedAt,
    this.elapsedDuration = Duration.zero,
  });

  bool get isFinished => elapsedDuration.inSeconds >= duration.inSeconds;

  bool get isRunning => startedAt != null && !isFinished;
}
