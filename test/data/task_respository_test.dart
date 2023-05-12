import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/drift_tables.dart';
import 'package:ipotato_timer/data/local_data_source.dart';
import 'package:ipotato_timer/data/task_respository.dart';

void main() {
  late AppDatabase database;
  late LocalDataSource localDataSource;

  setUp(() {
    database = AppDatabase(database: NativeDatabase.memory());
    localDataSource = LocalDataSource(database);
  });

  group('Task Tracker', () {
    test('Add task in db', () async {
      final repo = TaskRepository(localDataSource);
      final task = Task(
        title: 'T1',
        description: 'D1',
        duration: const Duration(seconds: 5),
      );

      await repo.addTask(task);

      final tasks = await localDataSource.getTasks();
      expect(tasks[0].title, 'T1');
      expect(tasks[0].description, 'D1');
      expect(tasks[0].duration.inSeconds, 5);
    });

    test('When task is played add the start time in db', () async {
      final repo = TaskRepository(localDataSource);
      final task = Task(title: 'T1', duration: const Duration(minutes: 1));
      final id = await localDataSource.addTask(task);

      await runFakeClock(DateTime(2017, 9, 7, 17, 30), () async {
        await repo.startTask(id);
      });

      final tasks = await localDataSource.getTasks();
      expect(tasks.first.title, 'T1');
      expect(tasks.first.startedAt.toString(), '2017-09-07 17:30:00.000');
    });
  });

  tearDown(() async {
    await database.close();
  });
}

T runFakeClock<T>(DateTime fakeClock, T Function() fn) {
  return withClock(Clock.fixed(fakeClock), fn);
}
