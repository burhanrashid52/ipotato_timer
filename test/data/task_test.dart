import 'package:flutter_test/flutter_test.dart';

import '../test_helper.dart';

void main() {
  final taskBuilder = TaskDataBuilder(
    id: 0,
    title: 'T1',
    description: 'D1',
    duration: Duration.zero,
  );
  group('Tasks', () {
    test(
      'Return isFinished true when elapsed time is more than given duration',
      () {
        final task = taskBuilder
            .duration(const Duration(seconds: 5))
            .elapsedDuration(const Duration(seconds: 6))
            .build();
        expect(task.isFinished, true);
      },
    );

    test(
      'Return isFinished false when elapsed time is less than given duration',
      () {
        final task = taskBuilder
            .duration(const Duration(seconds: 5))
            .elapsedDuration(const Duration(seconds: 4))
            .build();
        expect(task.isFinished, false);
      },
    );

    test(
      'Return isFinished true when elapsed time is equal to duration',
      () {
        final task = taskBuilder
            .duration(const Duration(seconds: 5))
            .elapsedDuration(const Duration(seconds: 5))
            .build();
        expect(task.isFinished, true);
      },
    );

    test(
      'Return isRunning true when we have started time and not finished',
      () {
        final task = taskBuilder
            .duration(const Duration(seconds: 5))
            .startedAt(DateTime.now())
            .build();
        expect(task.isRunning, true);
      },
    );
    test(
      'Return isRunning false when we do not have started time',
      () {
        final task = taskBuilder.duration(const Duration(seconds: 5)).build();
        expect(task.isRunning, false);
      },
    );
    test(
      'Return isRunning false when we have started time but finished',
      () {
        final task = taskBuilder
            .duration(const Duration(seconds: 5))
            .startedAt(DateTime.now())
            .elapsedDuration(const Duration(seconds: 5))
            .build();
        expect(task.isRunning, false);
      },
    );
  });

  group('Total Elapsed duration', () {
    test('Return elapsed duration when no start time found', () {
      final task = taskBuilder
          .duration(const Duration(seconds: 5))
          .elapsedDuration(const Duration(seconds: 2))
          .build();

      expect(task.totalElapsed, const Duration(seconds: 2));
    });
    test('Return total elapsed duration when start time found', () {
      runFakeClock(DateTime(2022, 5, 13, 8, 55), () {
        final task = taskBuilder
            .duration(const Duration(minutes: 10))
            .elapsedDuration(const Duration(minutes: 2))
            .startedAt(DateTime(2022, 5, 13, 8, 51))
            .build();
        expect(task.totalElapsed, const Duration(minutes: 6));
      });
    });
  });
}
