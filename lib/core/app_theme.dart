import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xffe86114);
  static const dark = Color(0xff1f2125);
  static const secondary = Color(0xff27292d);
  static const actions = Color(0xFFFF9800);
  static const success = Color(0xFF73ba00);
  static const warning = Color(0xffff5c00);
  static const textGrey = Color(0xffc2c2c2);
}

extension ColorSchemeExt on ColorScheme {
  Color get primary => AppColors.primary;
  Color get secondary => AppColors.secondary;
  Color get actions => AppColors.actions;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      secondaryHeaderColor: AppColors.secondary,
      scaffoldBackgroundColor: const Color(0xfff8f9fa),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: AppColors.secondary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.secondary),
      unselectedWidgetColor: Colors.black45,
      primaryColorLight: AppColors.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
          secondary: AppColors.secondary,
          primary: AppColors.primary,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: const TextStyle(color: Colors.white),
        labelColor: Colors.white,
        dividerColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(180),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
      ),
    );
  }

  static get darkTheme => ThemeData(
        //brightness: Brightness.dark,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.dark).copyWith(
          surface: AppColors.dark,
          onSurface: Colors.white,
          primary: AppColors.primary,
          error: AppColors.warning,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(AppColors.primary),
          ),
        ),
        hoverColor: AppColors.secondary,
        iconTheme: const IconThemeData(
          color: AppColors.textGrey,
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(color: AppColors.textGrey),
          iconColor: AppColors.textGrey,
          selectedTileColor: AppColors.secondary,
          selectedColor: Colors.white,
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          surfaceTintColor: AppColors.secondary,
          color: AppColors.dark,
          shadowColor: AppColors.secondary,
        ),
        cardTheme: const CardTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          //shape: Border(left: BorderSide(color: Color(0xff383838), width: 1)),
        ),
        dividerColor: const Color(0xff383838),
        dividerTheme: const DividerThemeData(
          color: Color(0xff383838),
          space: 1,
        ),
        dialogBackgroundColor: AppColors.dark,
        dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
          contentTextStyle: TextStyle(color: AppColors.textGrey),
          surfaceTintColor: Colors.black,
          backgroundColor: AppColors.dark,
          shadowColor: AppColors.dark,
          actionsPadding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      );
}
