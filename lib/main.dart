import 'package:flutter/material.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/task_list_page.dart';

void main() {
  registerDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Timer',
      theme: ThemeData(
        primaryColor: const Color(0xFF006782),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          cardColor: const Color(0xFFFBFCFE),
        ).copyWith(
          tertiary: const Color(0xFF5B5B7D),
          surface: const Color(0xFFFBFCFE),
        ),
        iconTheme: const IconThemeData(
          size: 18,
        ),
      ),
      home: const TaskListPage(),
    );
  }
}
