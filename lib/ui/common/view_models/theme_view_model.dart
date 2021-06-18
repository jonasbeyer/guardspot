import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/preferences/preference_storage.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:guardspot/util/extensions/theme_extensions.dart';

@injectable
class ThemeViewModel extends BaseViewModel {
  final PreferenceStorage _preferenceStorage;

  ThemeViewModel(this._preferenceStorage);

  ThemeMode get currentThemeMode =>
      themeModeFromStorageKey(_preferenceStorage.selectedTheme.get());

  Stream<ThemeMode> get observableThemeMode =>
      _preferenceStorage.selectedTheme.subject
          .map((key) => themeModeFromStorageKey(key));
}
