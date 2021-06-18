import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Diese Seite konnte nicht gefunden werden."),
      ),
    );
  }
}
