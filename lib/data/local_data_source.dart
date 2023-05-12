import 'package:drift/drift.dart';
import 'package:ipotato_timer/data/drift_tables.dart';

class LocalDataSource {
  final AppDatabase _db;

  LocalDataSource(this._db);

  Stream<List<Task>> watchTasks() => _selectTask.watch().map(
        (items) => items.map(Task.fromTable).toList(),
      );

  Future<List<Task>> getTasks() async {
    return await _selectTask.map(Task.fromTable).get();
  }

  SimpleSelectStatement<$TasksTable, TaskTable> get _selectTask =>
      _db.select(_db.tasks);

  Future<int> addTask(Task task) {
    final taskTable = TasksCompanion.insert(
      title: task.title,
      description: Value(task.description),
      duration: task.duration.inMilliseconds,
      startedAt: task.startedAt?.millisecondsSinceEpoch ?? 0,
      elapsedDuration: Value(task.elapsedDuration.inMilliseconds),
    );
    return _db.into(_db.tasks).insert(taskTable);
  }

  Future<int> removeTask(int id) {
    final taskTable = TasksCompanion(id: Value(id));
    return _db.delete(_db.tasks).delete(taskTable);
  }

  Future<void> updateTask(
    int id, {
    int startedAt = 0,
    int? elapsed,
  }) {
    final taskTable = TasksCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      elapsedDuration: elapsed != null ? Value(elapsed) : const Value.absent(),
    );
    final query = _db.update(_db.tasks)..where((e) => e.id.equals(id));
    return query.write(taskTable);
  }

  Future<Task?> getTask(int id) {
    final query = _selectTask..where((t) => t.id.equals(id));
    final result = query.map(Task.fromTable);
    return result.getSingleOrNull();
  }
}

class Task {
  final String title;
  final Duration duration;
  final String? description;
  final DateTime? startedAt;
  final Duration elapsedDuration;

  factory Task.fromTable(TaskTable table) {
    return Task(
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
    required this.title,
    required this.duration,
    this.description,
    this.startedAt,
    this.elapsedDuration = Duration.zero,
  });
}
