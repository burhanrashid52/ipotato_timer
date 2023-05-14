import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/home/task_list_page.dart';
import 'package:ipotato_timer/main.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() => getIt.allowReassignment = true);
  const defaultTask = Task(
    id: 1,
    title: 'T1',
    duration: Duration(seconds: 30),
  );
  group('Task List', () {
    testWidgets(
      'Show finished task',
      (tester) async {
        getIt.registerSingleton<TaskRepository>(
          FakeTaskRepository(
              fakeTasksStream: Stream.value(
            [
              defaultTask.copyWith(
                elapsedDuration: const Duration(seconds: 30),
              ),
            ],
          )),
        );
        await tester.pumpWidget(
          const TaskListPage().wrapScaffold().wrapMaterialApp(),
        );
        await tester.pumpAndSettle();
        expect(find.text('T1'), findsOneWidget);
        expect(find.text('FINISHED'), findsOneWidget);
        expect(find.text('MARK COMPLETE'), findsOneWidget);
      },
    );

    testWidgets(
      'Show running task',
      (tester) async {
        getIt.registerSingleton<TaskRepository>(
          FakeTaskRepository(
            fakeTasksStream: Stream.value([
              defaultTask.copyWith(
                description: 'D1',
                elapsedDuration: const Duration(seconds: 15),
                startedAt: DateTime.now(),
              ),
            ]),
          ),
        );
        await tester.pumpWidget(
          const TaskListPage().wrapScaffold().wrapMaterialApp(),
        );
        await tester.pumpAndSettle();
        expect(find.text('T1'), findsOneWidget);
        expect(find.text('D1'), findsOneWidget);
        expect(find.byIcon(Icons.pause), findsOneWidget);
        expect(find.text('FINISHED'), findsNothing);
      },
    );

    testWidgets(
      'Open add task dialog',
      (tester) async {
        getIt.registerSingleton<TaskRepository>(FakeTaskRepository());
        await tester.pumpWidget(
          const TaskListPage().wrapScaffold().wrapMaterialApp(),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      },
    );

    testWidgets(
      'Delete task on swipe',
      (tester) async {
        final fakeRepo = FakeTaskRepository(
          fakeTasksStream: Stream.value([
            defaultTask.copyWith(
              description: 'D1',
              duration: const Duration(seconds: 15),
              elapsedDuration: const Duration(seconds: 15),
            ),
          ]),
        );
        getIt.registerSingleton<TaskRepository>(fakeRepo);

        await tester.pumpWidget(
          const TaskListPage().wrapScaffold().wrapMaterialApp(),
        );
        await tester.pumpAndSettle();

        await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(fakeRepo.deletedTaskId, 1);
      },
    );
  });

  group('TaskTimerToggle', () {
    testWidgets('Start task when task is not running', (tester) async {
      final task = defaultTask.copyWith(
        description: 'D1',
        duration: const Duration(seconds: 15),
      );

      final fakeRepo = FakeTaskRepository();
      getIt.registerSingleton<TaskRepository>(fakeRepo);

      await tester.pumpWidget(
        TaskTimerToggle(task: task).wrapScaffold().wrapMaterialApp(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      expect(fakeRepo.startedTaskId, 1);
    });

    testWidgets('Pause task when task is running', (tester) async {
      final task = defaultTask.copyWith(
        description: 'D1',
        duration: const Duration(seconds: 15),
        elapsedDuration: const Duration(seconds: 10),
        startedAt: DateTime.now(),
      );

      final fakeRepo = FakeTaskRepository();
      getIt.registerSingleton<TaskRepository>(fakeRepo);

      await tester.pumpWidget(
        TaskTimerToggle(task: task).wrapScaffold().wrapMaterialApp(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pumpAndSettle();

      expect(fakeRepo.pausedTaskId, 1);
    });
  });
}
