import 'package:drift/drift.dart';
import 'package:ipotato_timer/data/drift_tables.dart';

import 'data_source.dart';

class LocalDataSource implements DataSource {
  final AppDatabase _db;

  LocalDataSource(this._db);

  @override
  Stream<List<Task>> watchTasks() => _selectTask.watch().map(
        (items) => items.map(_taskFromTable).toList(),
      );

  @override
  Future<List<Task>> getTasks() async {
    return await _selectTask.map(_taskFromTable).get();
  }

  SimpleSelectStatement<$TasksTable, TaskTable> get _selectTask =>
      _db.select(_db.tasks);

  @override
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

  @override
  Future<int> removeTask(int id) {
    final taskTable = TasksCompanion(id: Value(id));
    return _db.delete(_db.tasks).delete(taskTable);
  }

  @override
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

  @override
  Future<Task?> getTask(int id) {
    final query = _selectTask..where((t) => t.id.equals(id));
    final result = query.map(_taskFromTable);
    return result.getSingleOrNull();
  }
}

Task _taskFromTable(TaskTable table) {
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
