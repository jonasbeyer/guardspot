import 'package:flutter/material.dart';
import 'package:guardspot/util/layout/adaptive.dart';

class AdaptiveInputBody extends StatelessWidget {
  final Widget child;
  final Alignment? alignment;
  final EdgeInsets? margin;
  final double? width;

  AdaptiveInputBody({
    required this.child,
    this.alignment,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = isDisplayDesktop(context);
    Alignment alignment = this.alignment ??
        (isDesktop ? Alignment(-0.25, -0.15) : Alignment.topLeft);

    return Scrollbar(
      child: Align(
        alignment: alignment,
        child: SingleChildScrollView(
          child: Container(
            child: SizedBox(width: width ?? 500, child: child),
            margin:
                margin ?? (isDesktop ? EdgeInsets.zero : EdgeInsets.all(16.0)),
          ),
        ),
      ),
    );
  }
}
