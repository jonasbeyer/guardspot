import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/theme.dart';

class ProgressIndicatorOverlay extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Color color;

  ProgressIndicatorOverlay({
    required this.child,
    required this.visible,
    this.color = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !visible,
      child: Stack(
        children: [
          child,
          Visibility(
            visible: visible,
            child: ModalBarrier(color: color, dismissible: false),
          ),
          Visibility(
            visible: visible,
            child: Center(
              child: Theme(
                data: AppTheme.darkThemeData,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
