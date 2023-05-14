import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/add_task/add_task.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/main.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() {
    getIt.registerSingleton<TaskRepository>(
      TaskRepository(
        LocalDataSource(
          AppDatabase(database: NativeDatabase.memory()),
        ),
      ),
    );
  });
  group('Add Task', () {
    testWidgets(
      'Show error when title is empty',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            const AddTaskPage().wrapScaffold().wrapMaterialApp(),
          );
          await tester.pumpAndSettle();
          await tester.tapOnText('Add Task');
          expect(find.text('Title cannot be empty'), findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show error when duration is zero',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            const AddTaskPage().wrapScaffold().wrapMaterialApp(),
          );
          await tester.pumpAndSettle();
          await tester.enterTextKey('text_field_title', 'Task 1');
          await tester.tapOnText('Add Task');
          expect(find.text('Duration cannot be 0'), findsOneWidget);
        });
      },
    );

    testWidgets(
      'Add valid task',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            const AddTaskPage().wrapScaffold().wrapMaterialApp(),
          );
          await tester.pumpAndSettle();
          await tester.enterTextKey('text_field_title', 'Task 1');
          await tester.enterTextKey('text_field_description', 'Description 1');
          await tester.enterTextKey('text_field_SS', '10');

          await tester.tapOnText('Add Task');

          final result = await repository.watchTasks().first;
          expect(result.first.title, 'Task 1');
          expect(result.first.description, 'Description 1');
          expect(result.first.duration, const Duration(seconds: 10));
        });
      },
    );
  });
}
