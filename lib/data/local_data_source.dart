import 'package:drift/drift.dart';
import 'package:ipotato_timer/data/drift_tables.dart';

class LocalDataSource {
  final AppDatabase _db;

  Stream<List<Task>> watchTasks() => _db.select(_db.tasks).watch().map(
        (items) => items
            .map((e) => Task(title: e.title, description: e.description))
            .toList(),
      );

  LocalDataSource(this._db);

  Future<List<Task>> getTasks() async {
    final items = await _db.select(_db.tasks).get();
    return items
        .map((e) => Task(title: e.title, description: e.description))
        .toList();
  }

  Future<int> addTask(Task task) {
    final taskTable = TasksCompanion.insert(
      title: task.title,
      description: Value(task.description),
      duration: 0,
    );
    return _db.into(_db.tasks).insert(taskTable);
  }

  Future<int> removeTask(int id) {
    final taskTable = TaskTable(id: id, title: 'title', duration: 0);
    return _db.delete(_db.tasks).delete(taskTable);
  }
}

class Task {
  final String title;
  final String? description;

  Task({
    required this.title,
    this.description,
  });
}
