import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class MarkerGenerator {
  final List<Widget> markerWidgets;
  final Completer<List<Uint8List>> result = Completer();

  MarkerGenerator(this.markerWidgets);

  Future<List<Uint8List>> generate(BuildContext context) {
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => afterFirstLayout(context));

    return result.future;
  }

  void afterFirstLayout(BuildContext context) => addOverlay(context);

  void addOverlay(BuildContext context) {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry entry = OverlayEntry(
      maintainState: true,
      builder: (context) => _MarkerHelper(
        markerWidgets: markerWidgets,
        result: result,
      ),
    );

    overlayState.insert(entry);
  }
}

class _MarkerHelper extends StatefulWidget {
  final List<Widget> markerWidgets;
  final Completer<List<Uint8List>> result;

  const _MarkerHelper({
    Key? key,
    required this.markerWidgets,
    required this.result,
  }) : super(key: key);

  @override
  _MarkerHelperState createState() => _MarkerHelperState();
}

class _MarkerHelperState extends State<_MarkerHelper> with AfterLayoutMixin {
  List<GlobalKey> globalKeys = [];

  @override
  void afterFirstLayout(BuildContext context) =>
      _getBitmaps(context).then((list) => widget.result.complete(list));

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: widget.markerWidgets.map((i) {
            final markerKey = GlobalKey();
            globalKeys.add(markerKey);
            return RepaintBoundary(
              key: markerKey,
              child: i,
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<List<Uint8List>> _getBitmaps(BuildContext context) async {
    var futures = globalKeys.map((key) => _getUint8List(key));
    return Future.wait(futures);
  }

  Future<Uint8List> _getUint8List(GlobalKey markerKey) async {
    RenderRepaintBoundary boundary =
        markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    return byteData.buffer.asUint8List();
  }
}

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}
