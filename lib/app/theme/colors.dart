import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const carolinaBlue = Color(0xFF8AB4F8);
  static const darkBlue = Color(0xFF3E4257);

  static const lightRed = Color(0xFFfcf2f2);
  static const darkRed = Color(0xFFd1453b);

  static Color textColorPrimary(ThemeData themeData) =>
      themeData.textTheme.bodyText1!.color!;

  static Color textColorSecondary(ThemeData themeData) =>
      themeData.textTheme.headline1!.color!;

  static const List<Color> priorityColors = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.redAccent,
  ];
}
