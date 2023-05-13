import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/add_task.dart';

import 'test_helper.dart';

void main() {
  group('Add Task', () {
    testWidgets(
      'Show error when title is empty',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            const MaterialApp(
              home: AddTaskPage(),
            ),
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
            const MaterialApp(
              home: AddTaskPage(),
            ),
          );
          await tester.pumpAndSettle();
          await tester.enterTextKey('text_field_title', 'Task 1');
          await tester.tapOnText('Add Task');
          expect(find.text('Duration cannot be 0'), findsOneWidget);
        });
      },
    );
  });
}
