import 'package:ipotato_timer/data/local_data_source.dart';
import 'package:ipotato_timer/data/task.dart';

import 'drift_tables.dart';

export "drift_tables.dart" show AppDatabase hide Tasks;
export 'task.dart';
export 'task_repository.dart';

abstract class DataSource {
  Stream<List<Task>> watchTasks();

  Future<int> addTask(Task task);

  Future<List<Task>> getTasks();

  Future<Task?> getTask(int id);

  Future<int> removeTask(int id);

  Future<void> updateTask(int id, {int startedAt = 0, int? elapsed});
}

DataSource createLocalDataSource() {
  return LocalDataSource(
    AppDatabase(),
  );
}
