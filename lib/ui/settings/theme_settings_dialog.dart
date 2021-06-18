import 'package:flutter/material.dart';
import 'package:guardspot/data/preferences/preference_storage.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/theme_extensions.dart';
import 'package:auto_route/auto_route.dart';

class ThemeSettingsDialog extends StatefulWidget {
  final PreferenceStorage storage;

  ThemeSettingsDialog({PreferenceStorage? storage})
      : this.storage = storage ?? locator();

  @override
  _ThemeSettingsDialogState createState() => _ThemeSettingsDialogState();
}

class _ThemeSettingsDialogState extends State<ThemeSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("settings_theme_title").t(context),
      contentPadding: EdgeInsets.only(top: 20.0, bottom: 24.0),
      content: SingleChildScrollView(
        child: _buildThemeList(ThemeMode.values),
      ),
    );
  }

  Widget _buildThemeList(List<ThemeMode> themeModes) {
    return Column(
      children: themeModes.map((themeMode) {
        return RadioListTile(
          title: Text(_getTitleKeyForThemeMode(themeMode)).t(context),
          onChanged: (selected) => _onThemeSelected(themeMode),
          value: themeMode.storageKey,
          groupValue: widget.storage.selectedTheme.get(),
        );
      }).toList(),
    );
  }

  void _onThemeSelected(ThemeMode themeMode) {
    widget.storage.selectedTheme.set(themeMode.storageKey);
    context.router.pop();
  }

  String _getTitleKeyForThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "settings_theme_light";
      case ThemeMode.dark:
        return "settings_theme_dark";
      default:
        return "settings_theme_system";
    }
  }
}
