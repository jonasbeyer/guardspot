import 'package:flutter/material.dart';
import 'package:guardspot/ui/common/widgets/progress_indicator_overlay.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class AddEditScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final EdgeInsets padding;
  final bool isSaving;
  final Widget? floatingActionButton;
  final Function() onSavePressed;

  AddEditScaffold({
    required this.title,
    required this.onSavePressed,
    required this.body,
    this.isSaving = false,
    this.padding = const EdgeInsets.all(16.0),
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressIndicatorOverlay(
      visible: isSaving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            TextButton(
              child: Text(context.getString("save").toUpperCase()),
              onPressed: onSavePressed,
            )
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            padding: padding,
            child: body,
          ),
        ),
      ),
    );
  }
}
