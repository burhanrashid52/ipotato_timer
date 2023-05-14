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
            fakeTasksStream: [
              defaultTask.copyWith(
                elapsedDuration: const Duration(seconds: 30),
              ),
            ],
          ),
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
            fakeTasksStream: [
              defaultTask.copyWith(
                description: 'D1',
                elapsedDuration: const Duration(seconds: 15),
                startedAt: DateTime.now(),
              ),
            ],
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
  });
}
