import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/widget/countdown_timer.dart';

void main() {
  group('Countdown Timer', () {
    testWidgets('Update timer every second', (tester) async {
      await runFakeAsync((async) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CountdownTimer(
                duration: Duration(seconds: 60),
                elapsedTime: Duration(seconds: 29),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('00:00:31'), findsOneWidget);

        await _elapseSeconds(async, tester, 5);
        expect(find.text('00:00:26'), findsOneWidget);

        await _elapseSeconds(async, tester, 8);
        expect(find.text('00:00:18'), findsOneWidget);
      });
    });

    testWidgets('Do not update timer when its stopped', (tester) async {
      await runFakeAsync((async) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CountdownTimer(
                duration: Duration(seconds: 60),
                elapsedTime: Duration(seconds: 29),
                stop: true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('00:00:31'), findsOneWidget);

        await _elapseSeconds(async, tester, 5);
        expect(find.text('00:00:31'), findsOneWidget);
      });
    });

    testWidgets('Call on finished when time is up', (tester) async {
      await runFakeAsync((async) async {
        var onFinishedCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountdownTimer(
                duration: const Duration(seconds: 30),
                elapsedTime: const Duration(seconds: 20),
                onFinished: () {
                  onFinishedCalled = true;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(onFinishedCalled, false);

        await _elapseSeconds(async, tester, 3);
        expect(onFinishedCalled, false);

        await _elapseSeconds(async, tester, 8);
        expect(onFinishedCalled, true);
      });
    });
  });
}

Future<void> _elapseSeconds(
  FakeAsync async,
  WidgetTester tester,
  int seconds,
) async {
  async.elapse(Duration(seconds: seconds));
  await tester.pumpAndSettle();
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
