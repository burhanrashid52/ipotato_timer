import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';

import '../test_helper.dart';

void main() {
  group('Tasks', () {
    test(
      'Return isFinished true when elapsed time is more than given duration',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
          elapsedDuration: const Duration(seconds: 6),
        );
        expect(task.isFinished, true);
      },
    );

    test(
      'Return isFinished false when elapsed time is less than given duration',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
          elapsedDuration: const Duration(seconds: 4),
        );
        expect(task.isFinished, false);
      },
    );

    test(
      'Return isFinished true when elapsed time is equal to duration',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
          elapsedDuration: const Duration(seconds: 5),
        );
        expect(task.isFinished, true);
      },
    );

    test(
      'Return isRunning true when we have started time and not finished',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
          startedAt: DateTime.now(),
        );
        expect(task.isRunning, true);
      },
    );
    test(
      'Return isRunning false when we do not have started time',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
        );
        expect(task.isRunning, false);
      },
    );
    test(
      'Return isRunning false when we have started time but finished',
      () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(seconds: 5),
          elapsedDuration: const Duration(seconds: 5),
          startedAt: DateTime.now(),
        );
        expect(task.isRunning, false);
      },
    );
  });

  group('Total Elapsed duration', () {
    test('Return elapsed duration when no start time found', () {
      final task = Task(
        id: 0,
        title: '',
        duration: const Duration(seconds: 5),
        elapsedDuration: const Duration(seconds: 2),
      );
      expect(task.totalElapsed, const Duration(seconds: 2));
    });
    test('Return total elapsed duration when start time found', () {
      runFakeClock(DateTime(2022, 5, 13, 8, 55), () {
        final task = Task(
          id: 0,
          title: '',
          duration: const Duration(minutes: 10),
          elapsedDuration: const Duration(minutes: 2),
          startedAt: DateTime(2022, 5, 13, 8, 51),
        );
        expect(task.totalElapsed, const Duration(minutes: 6));
      });
    });
  });
}
