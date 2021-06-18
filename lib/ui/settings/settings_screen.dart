import 'package:flutter/material.dart';
import 'package:guardspot/data/preferences/preference_storage.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/settings/settings_category.dart';
import 'package:guardspot/ui/settings/theme_settings_dialog.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  late PreferenceStorage _settings;

  @override
  void initState() {
    super.initState();
    _settings = locator();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          _buildThemeCategory(),
          _buildMapsCategory(),
          _buildNotificationsCategory(),
          _buildAboutCategory(),
        ],
      ).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildThemeCategory() {
    return ListTile(
      title: Text("settings_theme_title").t(context),
      onTap: () => showDialog(
        context: context,
        builder: (_) => ThemeSettingsDialog(),
      ),
    );
  }

  Widget _buildMapsCategory() {
    return SettingsCategory(
      title: "Karten",
      contentPadding: EdgeInsets.all(16.0),
      children: [
        TypedValueStreamBuilder(
          stream: _settings.mapsSatelliteMode.subject,
          builder: (bool data) => SwitchListTile(
            title: Text("Satellitenansicht"),
            onChanged: _settings.mapsSatelliteMode.set,
            value: data,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsCategory() {
    return SettingsCategory(
      title: context.getString("settings_notifications_category_title"),
      contentPadding: EdgeInsets.all(16.0),
      children: [
        TypedValueStreamBuilder(
          stream: _settings.notificationsEnabled.subject,
          builder: (bool data) => SwitchListTile(
            title: Text("settings_notifications_title").t(context),
            subtitle: Text("settings_notifications_summary").t(context),
            onChanged: _settings.notificationsEnabled.set,
            value: data,
          ),
        ),
        TypedValueStreamBuilder(
          stream: _settings.notificationVibration.subject,
          builder: (bool data) => SwitchListTile(
            title: Text("settings_notifications_vibration_title").t(context),
            subtitle:
                Text("settings_notifications_vibration_summary").t(context),
            onChanged: _settings.notificationVibration.set,
            value: data,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCategory() {
    return SettingsCategory(
      title: context.getString("settings_about_category_title"),
      children: [
        ListTile(
          title: Text("settings_app_version").t(context),
          subtitle: Text("1.0.0"),
        ),
        ListTile(
          title: Text("settings_app_developed_by").t(context),
          subtitle: Text("Twisted IT"),
        ),
        ListTile(
          title: Text("settings_privacy_policy").t(context),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (builder) => Container(
              padding: EdgeInsets.all(25.0),
              child: Text("Hier stehen unsere Datenschutzerklärungen"),
            ),
          ),
        ),
      ],
    );
  }
}
