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
    const primaryColor = Color(0xFF006782);
    const secondaryColor = Color(0xFF216C2E);
    const tertiaryContainer = Color(0xFFE1DFFF);
    return MaterialApp(
      title: 'Potato Timer',
      theme: ThemeData(
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: secondaryColor,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          cardColor: const Color(0xFFFBFCFE),
        ).copyWith(
          tertiary: const Color(0xFF5B5B7D),
          tertiaryContainer: tertiaryContainer,
          surface: const Color(0xFFFBFCFE),
          primary: primaryColor,
          secondary: secondaryColor,
          onSecondary: const Color(0xFFFFFFFF),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Change the corner size
          ),
          buttonColor: tertiaryContainer,
        ),
        iconTheme: const IconThemeData(
          size: 18,
        ),
      ),
      home: const TaskListPage(),
    );
  }
}
