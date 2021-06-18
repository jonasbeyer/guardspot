import 'package:flutter/material.dart';

void showAdaptiveInput({
  required BuildContext context,
  required Widget dialogWidget,
  Widget? scaffoldWidget,
}) {
  if (isDisplayDesktop(context)) {
    showDialog(context: context, builder: (_) => dialogWidget);
  } else {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => scaffoldWidget ?? dialogWidget,
    ));
  }
}

bool isDisplayDesktop(BuildContext context) =>
    isDisplayLargeDesktop(context) || isDisplaySmallDesktop(context);

bool isDisplayLargeDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1440;

bool isDisplaySmallDesktop(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width >= 1024 && width <= 1439;
}

EdgeInsets adaptivePadding(BuildContext context) {
  double verticalPadding = 16.0;
  double horizontalPadding = isDisplayLargeDesktop(context)
      ? 120
      : isDisplaySmallDesktop(context)
          ? 32
          : 16;
  return EdgeInsets.symmetric(
    vertical: verticalPadding,
    horizontal: horizontalPadding,
  );
}
