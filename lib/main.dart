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
      createLocalDataSource(),
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
    const primaryContainer = Color(0xFFB6EAFF);
    const onPrimaryContainer = Color(0xFF001F2A);
    const secondaryColor = Color(0xFF216C2E);
    const tertiaryContainer = Color(0xFFE1DFFF);
    const tertiary = Color(0xFF5B5B7D);
    const white = Color(0xFFFFFFFF);
    final surface = primaryColor.withOpacity(0.05);
    var colorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      cardColor: surface,
    );
    return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryColor,
      ),
      colorScheme: colorScheme.copyWith(
        tertiary: tertiary,
        tertiaryContainer: tertiaryContainer,
        surface: surface,
        primary: primaryColor,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondaryColor,
        onSecondary: white,
        background: surface,
      ),
      cardTheme: CardTheme(
        color: surface,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        buttonColor: tertiaryContainer,
      ),
      iconTheme: const IconThemeData(
        size: 24,
        color: white,
      ),
    );
  }
}
