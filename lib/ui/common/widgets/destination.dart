import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class Destination {
  final String titleKey;
  final IconData? icon;
  final Widget? widget;
  final PageRouteInfo? route;

  const Destination({
    required this.titleKey,
    this.icon,
    this.widget,
    this.route,
  });
}
