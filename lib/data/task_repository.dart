import 'package:clock/clock.dart';
import 'package:get_it/get_it.dart';
import 'package:ipotato_timer/data/data_source.dart';

final _getIt = GetIt.instance;

TaskRepository get repository => _getIt();

void registerDependencies() {
  _getIt.registerSingleton<TaskRepository>(
    TaskRepository(
      LocalDataSource(
        AppDatabase(),
      ),
    ),
  );
}

class TaskRepository {
  final LocalDataSource _localDataSource;

  TaskRepository(this._localDataSource);

  Stream<List<Task>> watchTasks() =>
      _localDataSource.watchTasks().map(_sortTaskByFinish);

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
    return _localDataSource.addTask(task);
  }

  Future<void> startTask(int id) async {
    final now = clock.now();
    final milliseconds = now.millisecondsSinceEpoch;
    await _localDataSource.updateTask(id, startedAt: milliseconds);
  }

  Future<Duration> pauseTask(int id) async {
    final task = await _localDataSource.getTask(id);
    if (task != null) {
      if (task.startedAt != null) {
        final duration = _getTotalElapsedDuration(task);
        await _localDataSource.updateTask(id, elapsed: duration.inMilliseconds);
        return duration;
      }
      //TODO: Handle errors on UI
      throw 'Cannot pause task that has not been started';
    }
    throw 'Task not found';
  }

  Duration _getTotalElapsedDuration(Task task) {
    final currentElapsed = clock.now().difference(task.startedAt!);
    final prevElapsed = task.elapsedDuration.inMilliseconds;
    final totalElapsed = currentElapsed.inMilliseconds + prevElapsed;
    return Duration(milliseconds: totalElapsed);
  }

  Future<int> stopTask(int id) {
    return _localDataSource.removeTask(id);
  }

  Future<void> markAsFinished(int id, Duration duration) async {
    await _localDataSource.updateTask(
      id,
      startedAt: 0,
      elapsed: duration.inMilliseconds,
    );
  }
}
