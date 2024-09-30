import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/features/home/home_screen.dart';
import 'package:cryptid/scope.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await Dependencies.initialize();

  runApp(DependenciesScope(
    dependencies: dependencies,
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
