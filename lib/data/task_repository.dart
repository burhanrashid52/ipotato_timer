import 'package:clock/clock.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/util/app_extension.dart';

class TaskRepository {
  final DataSource _dataSource;

  TaskRepository(this._dataSource);

  Stream<List<Task>> watchTasks() =>
      _dataSource.watchTasks().map(_sortTaskByFinish);

  List<Task> _sortTaskByFinish(List<Task> tasks) {
    return tasks
      ..sort(
        (a, b) {
          if (!a.isFinished && b.isFinished) {
            return 1;
          } else if (a.isFinished && !b.isFinished) {
            return -1;
          }
          return 0;
        },
      );
  }

  ({bool isValid, String errMsg}) validate(Task task) {
    if (task.title.isEmpty) {
      return (isValid: false, errMsg: 'Title cannot be empty');
    }
    if (task.duration.inMilliseconds == 0) {
      return (isValid: false, errMsg: 'Duration cannot be 0');
    }
    return (isValid: true, errMsg: '');
  }

  Future<int> addTask(Task task) {
    return _dataSource.addTask(task);
  }

  Future<void> startTask(int id) async {
    final now = clock.now();
    final milliseconds = now.millisecondsSinceEpoch;
    await _dataSource.updateTask(id, startedAt: milliseconds);
  }

  Future<Duration> pauseTask(int id) async {
    final task = await _dataSource.getTask(id);
    if (task != null) {
      if (task.startedAt != null) {
        final duration = _getTotalElapsedDuration(task);
        await _dataSource.updateTask(id, elapsed: duration.inMilliseconds);
        return duration;
      }
      throw 'Cannot pause task that has not been started';
    }
    throw 'Task not found';
  }

  Duration _getTotalElapsedDuration(Task task) {
    final currentElapsed = clock.now().difference(task.startedAt!);
    final prevElapsed = task.elapsedDuration;
    return currentElapsed.add(prevElapsed);
  }

  Future<int> deleteTask(int id) {
    return _dataSource.removeTask(id);
  }

  Future<void> markAsFinished(int id, Duration duration) async {
    await _dataSource.updateTask(
      id,
      startedAt: 0,
      elapsed: duration.inMilliseconds,
    );
  }
}
