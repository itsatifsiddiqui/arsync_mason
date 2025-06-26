import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static Color get primaryLight => const Color(0xff3d81f1);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryLight,
      dividerColor: Colors.black,
      scaffoldBackgroundColor: const Color(0XFFF5F5F5),
      cardColor: Colors.grey.shade200,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.light,
        primary: primaryLight,
        secondary: primaryLight,
        surface: const Color(0XFFF5F5F5),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
            backgroundColor: Colors.transparent,
            wordSpacing: 1,
            height: 1.5,
            decorationColor: Colors.transparent,
            decorationThickness: 1,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
