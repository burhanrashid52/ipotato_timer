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
              startedAt: e.startedAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(e.startedAt!)
                  : null),
        )
        .toList();
  }

  Future<int> addTask(Task task) {
    final taskTable = TasksCompanion.insert(
      title: task.title,
      description: Value(task.description),
      duration: task.duration.inMilliseconds,
    );
    return _db.into(_db.tasks).insert(taskTable);
  }

  Future<int> removeTask(int id) {
    final taskTable = TaskTable(id: id, title: 'title', duration: 0);
    return _db.delete(_db.tasks).delete(taskTable);
  }

  Future<void> updateStartAt(int id, int millisecond) {
    final taskTable = TasksCompanion(
      id: Value(id),
      startedAt: Value(millisecond),
    );
    var update = _db.update(_db.tasks);
    update.where((e) => e.id.equals(id));
    return update.write(taskTable);
  }
}

class Task {
  final String title;
  final Duration duration;
  final String? description;
  final DateTime? startedAt;

  Task({
    required this.title,
    required this.duration,
    this.description,
    this.startedAt,
  });
}
