import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';

import '../test_helper.dart';

void main() {
  late AppDatabase database;
  late LocalDataSource localDataSource;
  const defaultTask = Task(
    id: 0,
    title: 'T1',
    description: 'D1',
    duration: Duration.zero,
  );

  setUp(() {
    database = AppDatabase(database: NativeDatabase.memory());
    localDataSource = LocalDataSource(database);
  });

  group('Repository CRUD', () {
    test('Return task when add via repository', () async {
      final repo = TaskRepository(localDataSource);

      await repo.addTask(
        defaultTask.copyWith(
          duration: const Duration(seconds: 5),
        ),
      );

      final tasks = await localDataSource.getTasks();
      expect(tasks[0].title, 'T1');
      expect(tasks[0].description, 'D1');
      expect(tasks[0].duration.inSeconds, 5);
    });

    test('Return sorted isFinished task first', () async {
      final repo = TaskRepository(localDataSource);

      await repo.addTask(
        defaultTask.copyWith(
          duration: const Duration(seconds: 5),
        ),
      );

      await repo.addTask(
        defaultTask.copyWith(
          title: 'T2',
          description: 'D2',
          duration: const Duration(seconds: 5),
          elapsedDuration: const Duration(seconds: 5),
        ),
      );

      await repo.addTask(
        defaultTask.copyWith(
          title: 'T3',
          description: 'D3',
          duration: const Duration(seconds: 5),
        ),
      );

      final tasks = await repo.watchTasks().first;
      expect(tasks[0].title, 'T2');
      expect(tasks[1].title, 'T1');
      expect(tasks[2].title, 'T3');
    });
  });

  group('Task Tracker', () {
    test('Return start time from db when task is started', () async {
      final repo = TaskRepository(localDataSource);

      final id = await localDataSource.addTask(
        defaultTask.copyWith(
          duration: const Duration(minutes: 1),
        ),
      );

      await runFakeClock(DateTime(2017, 9, 7, 17, 30), () async {
        await repo.startTask(id);
      });

      final tasks = await localDataSource.getTasks();
      expect(tasks.first.title, 'T1');
      expect(tasks.first.startedAt.toString(), '2017-09-07 17:30:00.000');
    });

    test('Return elapsed time when task is paused than', () async {
      final repo = TaskRepository(localDataSource);
      final id = await localDataSource.addTask(
        defaultTask.copyWith(
          duration: const Duration(seconds: 10),
          startedAt: DateTime(2017, 9, 7, 17, 30, 9),
        ),
      );

      await runFakeClock(DateTime(2017, 9, 7, 17, 30, 11), () async {
        final elapsedTime = await repo.pauseTask(id);
        expect(elapsedTime.inSeconds, 2);
      });
    });

    test(
        'Return total elapsed time from previous value when task is paused than',
        () async {
      final repo = TaskRepository(localDataSource);

      final id = await localDataSource.addTask(
        defaultTask.copyWith(
          duration: const Duration(seconds: 10),
          elapsedDuration: const Duration(seconds: 5),
          startedAt: DateTime(2017, 9, 7, 17, 30, 9),
        ),
      );

      await runFakeClock(DateTime(2017, 9, 7, 17, 30, 11), () async {
        final elapsedTime = await repo.pauseTask(id);
        expect(elapsedTime.inSeconds, 7);
      });
    });
    test('Delete item when stop', () async {
      final repo = TaskRepository(localDataSource);

      final id1 = await localDataSource.addTask(defaultTask);
      final id2 = await localDataSource.addTask(
        defaultTask.copyWith(title: 'T2'),
      );

      final beforeTask = await localDataSource.watchTasks().first;
      expect(beforeTask.length, 2);

      final id = await repo.deleteTask(id1);
      expect(id, id1);

      final afterTask = await localDataSource.watchTasks().first;
      expect(afterTask.length, 1);
      expect(afterTask.first.id, id2);
    });

    test('Return id zero on delete unknown task', () async {
      final repo = TaskRepository(localDataSource);
      await localDataSource.addTask(defaultTask);

      final id = await repo.deleteTask(42);
      expect(id, 0);
    });
  });

  tearDown(() async {
    await database.close();
  });
}
