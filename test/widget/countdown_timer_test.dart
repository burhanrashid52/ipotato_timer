import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/widget/countdown_timer.dart';

import '../test_helper.dart';

void main() {
  group('Countdown Timer', () {
    testWidgets('Update timer every second', (tester) async {
      await runFakeAsync((async) async {
        await tester.pumpWidget(
          const CountdownTimer(
            duration: Duration(seconds: 60),
            elapsedTime: Duration(seconds: 29),
          ).wrapScaffold().wrapMaterialApp(),
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
          const CountdownTimer(
            duration: Duration(seconds: 60),
            elapsedTime: Duration(seconds: 29),
            stop: true,
          ).wrapScaffold().wrapMaterialApp(),
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
          CountdownTimer(
            duration: const Duration(seconds: 30),
            elapsedTime: const Duration(seconds: 20),
            onFinished: () {
              onFinishedCalled = true;
            },
          ).wrapScaffold().wrapMaterialApp(),
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
