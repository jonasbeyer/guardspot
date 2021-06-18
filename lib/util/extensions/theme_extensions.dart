import 'package:flutter/material.dart';

ThemeMode themeModeFromStorageKey(String storageKey) {
  return ThemeMode.values
      .firstWhere((it) => it.toString().split(".").last == storageKey);
}

extension ThemeModeExtensions on ThemeMode {
  String get storageKey => this.toString().split(".").last;
}