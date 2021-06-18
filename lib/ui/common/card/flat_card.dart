import 'package:flutter/material.dart';

class FlatCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  FlatCard({
    required this.child,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
