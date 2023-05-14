import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ipotato_timer/data/data_source.dart';
import 'package:ipotato_timer/home/splash_screen.dart';
import 'package:ipotato_timer/home/task_list_page.dart';
import 'package:ipotato_timer/util/sound_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerDependencies();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

TaskRepository get repository => getIt();

SoundManager get soundManager => getIt();

void registerDependencies() {
  getIt.registerSingleton(
    TaskRepository(
      LocalDataSource(
        AppDatabase(),
      ),
    ),
  );
  getIt.registerSingleton(SoundManager());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Timer',
      theme: _buildAppThemeData(),
      home: FutureBuilder(
        future: repository.watchTasks().first,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final errMsg = snapshot.error!.toString();
            return Center(
              child: Text(errMsg),
            );
          }
          if (snapshot.hasData) {
            return const TaskListPage();
          }
          return const SplashScreen();
        },
      ),
    );
  }

  ThemeData _buildAppThemeData() {
    const primaryColor = Color(0xFF006782);
    const secondaryColor = Color(0xFF216C2E);
    const tertiaryContainer = Color(0xFFE1DFFF);
    return ThemeData(
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
          borderRadius: BorderRadius.circular(20),
        ),
        buttonColor: tertiaryContainer,
      ),
      iconTheme: const IconThemeData(
        size: 18,
      ),
    );
  }
}
