import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';

void main() {
  group('Tasks', () {
    test(
      'Return isFinished true when elapsed time is more than given duration',
      () async {
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
      () async {
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
      () async {
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
      () async {
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
      'Return isRunning false when we dont have started time',
      () async {
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
      () async {
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
}
