import 'package:flutter/material.dart';
import 'package:guardspot/ui/common/widgets/blocking_progress_indicator.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class AsyncAlertDialog extends StatelessWidget {
  final Text title;
  final Widget content;

  final bool isProcessing;
  final bool isSubmittable;
  final VoidCallback onSubmitted;

  final double width;

  AsyncAlertDialog({
    required this.title,
    required this.content,
    required this.isProcessing,
    required this.onSubmitted,
    this.width = 500,
    this.isSubmittable = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Container(
        width: width,
        child: isProcessing ? BlockingProgressIndicator() : content,
      ),
      actions: [
        TextButton(
          child: Text(context.getString("cancel").toUpperCase()),
          onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(context.getString("ok").toUpperCase()),
          onPressed: isProcessing || !isSubmittable ? null : onSubmitted,
        )
      ],
    );
  }
}
