import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightThemeData = themeData(lightColorScheme);
  static ThemeData darkThemeData = themeData(darkColorScheme);

  static ThemeData themeData(ColorScheme scheme) {
    return ThemeData.from(
      colorScheme: scheme,
    ).copyWith(
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: kIsWeb ? DisabledTransitionsTheme() : null,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        helperMaxLines: 2,
        helperStyle: TextStyle(fontSize: 14.0),
        errorStyle: TextStyle(fontSize: 14.0),
      ),
    );
  }

  static const lightColorScheme = ColorScheme.light(
    primary: AppColors.darkBlue,
    secondary: AppColors.darkBlue,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  );

  static const darkColorScheme = ColorScheme.dark(
    primary: AppColors.carolinaBlue,
    secondary: AppColors.carolinaBlue,
  );

  static const smallInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.all(10.0),
  );
}

class DisabledTransitionsTheme extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return child;
  }
}
