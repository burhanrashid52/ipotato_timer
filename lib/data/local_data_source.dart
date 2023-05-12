import 'package:drift/drift.dart';
import 'package:ipotato_timer/data/drift_tables.dart';

class LocalDataSource {
  final AppDatabase _db;

  Stream<List<Task>> watchTasks() => _db.select(_db.tasks).watch().map(
        (items) => items
            .map(
              (e) => Task(
                title: e.title,
                description: e.description,
                duration: Duration(seconds: e.duration),
              ),
            )
            .toList(),
      );

  LocalDataSource(this._db);

  Future<List<Task>> getTasks() async {
    final items = await _db.select(_db.tasks).get();
    return items
        .map(
          (e) => Task(
            title: e.title,
            description: e.description,
            duration: Duration(milliseconds: e.duration),
            elapsedDuration: Duration(milliseconds: e.elapsedDuration ?? 0),
            startedAt: e.startedAt > 0
                ? DateTime.fromMillisecondsSinceEpoch(e.startedAt)
                : null,
          ),
        )
        .toList();
  }

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

  Future<void> updateStartAt(int id, int millisecond, {int? elapsed}) {
    final taskTable = TasksCompanion(
      id: Value(id),
      startedAt: Value(millisecond),
      elapsedDuration: elapsed != null ? Value(elapsed) : const Value.absent(),
    );
    var update = _db.update(_db.tasks);
    update.where((e) => e.id.equals(id));
    return update.write(taskTable);
  }

  Future<Task?> getTask(int id) {
    final query = _db.select(_db.tasks)..where((t) => t.id.equals(id));
    var map = query.map(
      (row) => Task(
        title: row.title,
        description: row.description,
        duration: Duration(milliseconds: row.duration),
        elapsedDuration: Duration(milliseconds: row.elapsedDuration ?? 0),
        startedAt: row.startedAt > 0
            ? DateTime.fromMillisecondsSinceEpoch(row.startedAt)
            : null,
      ),
    );
    return map.getSingleOrNull();
  }
}

class Task {
  final String title;
  final Duration duration;
  final String? description;
  final DateTime? startedAt;
  final Duration elapsedDuration;

  Task({
    required this.title,
    required this.duration,
    this.description,
    this.startedAt,
    this.elapsedDuration = Duration.zero,
  });
}
