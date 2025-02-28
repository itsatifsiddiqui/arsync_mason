import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AppTheme {
  static Color get primaryLight => const Color(0x000000ff{{{primaryColorHexCode}}});
  {{#hasDarkMode}}
  static Color get primaryDark => const Color(0x000000ff{{{primaryColorHexCodeDark}}});
  {{/hasDarkMode}}

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
      {{#hasCustomFont}}
      fontFamily: '{{{fontname}}}',
      {{/hasCustomFont}}
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


   {{#hasDarkMode}}
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryDark,
      cardColor: const Color(0XFF242424),
      dividerColor: Colors.white,
      {{#hasCustomFont}}
      fontFamily: '{{{fontname}}}',
      {{/hasCustomFont}}
      scaffoldBackgroundColor: const Color(0xff1B1B1B),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        brightness: Brightness.dark,
        primary: primaryDark,
        secondary: primaryDark,
        surface: const Color(0XFFF5F5F5),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontSize: 30,
            color: Colors.white,
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
  {{/hasDarkMode}}
  
}
