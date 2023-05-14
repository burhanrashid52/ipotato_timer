import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ipotato_timer/add_task/add_task.dart';
import 'package:ipotato_timer/main.dart' as app;
import 'package:ipotato_timer/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    app.registerDependencies();
    //Delete all the tasks before running the tests
    final tasks = await repository.watchTasks().first;
    for (final e in tasks) {
      await repository.deleteTask(e.id);
    }
  });

  testWidgets('Add task and show on home page', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('T1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('text_field_title')), 'T1');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('text_field_SS')), '42');
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Add Task'),
      find.byType(AddTaskPage),
      const Offset(-250, 0),
    );

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('T1'), findsOneWidget);
    expect(find.text('00:00:41'), findsOneWidget);
  });
}
