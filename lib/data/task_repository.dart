import 'package:clock/clock.dart';
import 'package:ipotato_timer/data/local_data_source.dart';

class TaskRepository {
  final LocalDataSource _localDataSource;

  TaskRepository(this._localDataSource);

  //TODO: sort by finished items first here
  Stream<List<Task>> watchTasks() => _localDataSource.watchTasks();

  Future<int> addTask(Task task) {
    //TODO: Add validation for task here
    return _localDataSource.addTask(task);
  }

  Future<void> startTask(int id) async {
    final now = clock.now();
    final milliseconds = now.millisecondsSinceEpoch;
    await _localDataSource.updateStartAt(id, milliseconds);
  }

  Future<Duration> pauseTask(int id) async {
    final task = await _localDataSource.getTask(id);
    if (task != null) {
      final diff = clock.now().difference(task.startedAt!);
      final totalElapsed =
          diff.inMilliseconds + task.elapsedDuration.inMilliseconds;
      await _localDataSource.updateStartAt(
        id,
        0,
        elapsed: totalElapsed,
      );
      return Duration(milliseconds: totalElapsed);
    }
    throw 'Task not found';
  }
}
