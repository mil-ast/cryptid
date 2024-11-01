import 'package:cryptid/core/app_theme.dart';
import 'package:cryptid/core/widgets/app_scope_widget.dart';
import 'package:cryptid/features/home/home_screen.dart';
import 'package:cryptid/scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await Dependencies.initialize();

  runApp(
    DependenciesScope(
      dependencies: dependencies,
      child: MaterialApp(
        title: 'Cryptid',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
        ],
        locale: const Locale('ru', 'RU'),
        home: const AppScopeWidget(
          child: HomeScreen(),
        ),
      ),
    ),
  );
}
