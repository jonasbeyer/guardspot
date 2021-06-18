import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';

extension LocaleExtensions on Text {
  Text t(BuildContext context, {Map<String, Object>? arguments}) {
    return Text(
      context.getString(data!, arguments: arguments),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
    );
  }
}

extension BuildContextExtensions on BuildContext {
  String getString(
    String key, {
    Map<String, Object>? arguments,
  }) {
    I18Next i18Next = I18Next.of(this)!;
    return i18Next.t(key, variables: arguments);
  }
}
