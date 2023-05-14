import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';

extension WidgetExt on Widget {
  Widget wrapMaterialApp() {
    return MaterialApp(
      home: this,
    );
  }

  Widget wrapScaffold() {
    return Scaffold(
      body: this,
    );
  }
}

extension WidgetTesterExt on WidgetTester {
  Future<void> tapOnText(String text) async {
    await tap(find.text(text));
    await pumpAndSettle();
  }

  Future<void> enterTextKey(String fieldKey, String givenText) async {
    await enterText(find.byKey(ValueKey(fieldKey)), givenText);
    await pumpAndSettle();
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

class FakeTaskRepository extends Fake implements TaskRepository {
  final Stream<List<Task>>? fakeTasksStream;
  final Object? fakeStreamError;

  FakeTaskRepository({this.fakeTasksStream, this.fakeStreamError});

  var deletedTaskId = -1;
  var startedTaskId = -1;
  var pausedTaskId = -1;

  @override
  Stream<List<Task>> watchTasks() => fakeTasksStream ?? Stream.value([]);

  @override
  Future<int> deleteTask(int id) async {
    deletedTaskId = id;
    return id;
  }

  @override
  Future<void> startTask(int id) async {
    startedTaskId = id;
  }

  @override
  Future<Duration> pauseTask(int id) async {
    pausedTaskId = id;
    return Duration.zero;
  }
}
