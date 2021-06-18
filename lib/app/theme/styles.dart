import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';

class TextStyles {
  TextStyles._();

  static TextStyle primaryTitle(ThemeData themeData) =>
      themeData.textTheme.headline4!.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textColorPrimary(themeData),
      );

  static TextStyle secondaryTitle(ThemeData themeData) =>
      themeData.textTheme.headline6!.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textColorPrimary(themeData),
      );

  static TextStyle secondarySubtitle(ThemeData themeData) =>
      themeData.textTheme.subtitle1!
          .copyWith(color: AppColors.textColorSecondary(themeData));

  static TextStyle sectionHeader(ThemeData themeData) =>
      themeData.textTheme.bodyText2!.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textColorSecondary(themeData),
      );

  static TextStyle successText = TextStyle(color: Colors.green);

  static TextStyle errorText(ThemeData themeData) =>
      TextStyle(color: themeData.errorColor);

  static TextStyle cardTitleText(ThemeData themeData) => TextStyle(
        fontSize: 18.0,
        color: AppColors.textColorPrimary(themeData),
      );

  static TextStyle cardDescriptionText(ThemeData themeData) => TextStyle(
        fontSize: 16.5,
        color: AppColors.textColorSecondary(themeData),
      );

  static TextStyle contentLoadingErrorTitle(ThemeData themeData) => TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textColorPrimary(themeData),
      );

  static TextStyle contentLoadingErrorDescription(ThemeData themeData) =>
      themeData.textTheme.subtitle1!
          .copyWith(color: AppColors.textColorSecondary(themeData));
}
