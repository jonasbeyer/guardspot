import 'package:flutter/material.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';

extension ScaffoldExtensions on BuildContext {
  void showLocalizedSnackBar(String messageKey) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(this);
    SnackBar snackBar = SnackBar(
      width: isDisplayDesktop(this) ? 500 : null,
      behavior: SnackBarBehavior.floating,
      content: Text(messageKey).t(this),
    );

    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  }
}
