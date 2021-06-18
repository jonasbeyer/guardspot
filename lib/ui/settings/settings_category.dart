import 'package:flutter/material.dart';

class SettingsCategory extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets? contentPadding;

  SettingsCategory({
    required this.title,
    required this.children,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15.0,
            ),
          ),
        ),
        ListTileTheme(
          child: Column(children: children),
          contentPadding: contentPadding,
        ),
      ],
    );
  }
}
