import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:ipotato_timer/data/data_source.dart';

class TaskDataBuilder {
  final int _id;
  final String _title;
  final String? _description;
  final Duration? _duration;
  final Duration? _elapsedDuration;
  final DateTime? _startedAt;

  TaskDataBuilder({
    int id = 0,
    String title = '',
    String? description,
    Duration? duration,
    Duration? elapsedDuration,
    DateTime? startedAt,
  })  : _id = id,
        _title = title,
        _description = description,
        _duration = duration,
        _elapsedDuration = elapsedDuration,
        _startedAt = startedAt;

  TaskDataBuilder id(int id) {
    return TaskDataBuilder(
      id: id,
      title: _title,
      description: _description,
      duration: _duration,
      elapsedDuration: _elapsedDuration,
      startedAt: _startedAt,
    );
  }

  TaskDataBuilder title(String title) {
    return TaskDataBuilder(
      id: _id,
      title: title,
      description: _description,
      duration: _duration,
      elapsedDuration: _elapsedDuration,
      startedAt: _startedAt,
    );
  }

  TaskDataBuilder description(String description) {
    return TaskDataBuilder(
      id: _id,
      title: _title,
      description: description,
      duration: _duration,
      elapsedDuration: _elapsedDuration,
      startedAt: _startedAt,
    );
  }

  TaskDataBuilder duration(Duration duration) {
    return TaskDataBuilder(
      id: _id,
      title: _title,
      description: _description,
      duration: duration,
      elapsedDuration: _elapsedDuration,
      startedAt: _startedAt,
    );
  }

  TaskDataBuilder elapsedDuration(Duration elapsedDuration) {
    return TaskDataBuilder(
      id: _id,
      title: _title,
      description: _description,
      duration: _duration,
      elapsedDuration: elapsedDuration,
      startedAt: _startedAt,
    );
  }

  TaskDataBuilder startedAt(DateTime startedAt) {
    return TaskDataBuilder(
      id: _id,
      title: _title,
      description: _description,
      duration: _duration,
      elapsedDuration: _elapsedDuration,
      startedAt: startedAt,
    );
  }

  Task build() {
    return Task(
      id: _id,
      title: _title,
      description: _description,
      duration: _duration ?? Duration.zero,
      elapsedDuration: _elapsedDuration ?? Duration.zero,
      startedAt: _startedAt,
    );
  }
}

T runFakeClock<T>(DateTime fakeClock, T Function() fn) {
  return withClock(Clock.fixed(fakeClock), fn);
}

/// Runs a callback using FakeAsync.run while continually pumping the
/// microtask queue. This avoids a deadlock when tests `await` a Future
/// which queues a microtask that will not be processed unless the queue
/// is flushed.
Future<T> runFakeAsync<T>(
  Future<T> Function(FakeAsync time) f, {
  DateTime? initialTime,
}) async {
  return FakeAsync(
    initialTime: initialTime,
  ).run((FakeAsync time) async {
    var pump = true;
    final future = f(time).whenComplete(() => pump = false);
    while (pump) {
      time.flushMicrotasks();
    }
    return future;
  });
}
