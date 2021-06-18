import 'package:flutter/material.dart';

class InkCard extends StatelessWidget {
  final Widget? header;
  final double headerHeight;

  final Widget body;
  final EdgeInsets bodyPadding;

  final VoidCallback? onTap;
  final List<Widget>? buttons;

  InkCard({
    required this.body,
    this.header,
    this.onTap,
    this.buttons,
    this.headerHeight = 180.0,
    this.bodyPadding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child:
          header != null ? _buildBodyWithHeader() : _buildBodyWithoutHeader(),
    );
  }

  Widget _buildBodyWithHeader() {
    return Stack(
      children: [
        Positioned(child: SizedBox(height: headerHeight, child: header)),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap),
          ),
        ),
        Column(
          children: [
            SizedBox(height: headerHeight),
            Padding(padding: bodyPadding, child: IgnorePointer(child: body)),
          ],
        )
      ],
    );
  }

  Widget _buildBodyWithoutHeader() {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: bodyPadding, child: body),
      ),
    );
  }
}
