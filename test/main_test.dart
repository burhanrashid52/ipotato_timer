import 'package:flutter_test/flutter_test.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/home/splash_screen.dart';
import 'package:ipotato_timer/home/task_list_page.dart';
import 'package:ipotato_timer/main.dart';

import 'test_helper.dart';

void main() {
  setUpAll(() => getIt.allowReassignment = true);
  testWidgets(
    'Show splash screen on loading',
    (tester) async {
      getIt.registerSingleton<TaskRepository>(FakeTaskRepository());
      await tester.pumpWidget(const MyApp());
      expect(find.byType(SplashScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Show task list page on future complete',
    (tester) async {
      getIt.registerSingleton<TaskRepository>(FakeTaskRepository());
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(TaskListPage), findsOneWidget);
    },
  );

  testWidgets(
    'Show error when future fails',
    (tester) async {
      getIt.registerSingleton<TaskRepository>(FakeTaskRepository(
        fakeTasksStream: Stream.error('Error'),
      ));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    },
  );
}
