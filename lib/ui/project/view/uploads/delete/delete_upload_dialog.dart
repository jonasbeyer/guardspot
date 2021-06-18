import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/uploads/delete/delete_upload_view_model.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class DeleteUploadDialog extends StatefulWidget {
  final Upload upload;
  final bool shouldPop;

  DeleteUploadDialog(this.upload, {this.shouldPop = false});

  @override
  _DeleteUploadDialogState createState() => _DeleteUploadDialogState();
}

class _DeleteUploadDialogState extends State<DeleteUploadDialog> {
  late DeleteUploadViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((_) {
      context.showLocalizedSnackBar("upload_deleted");
      Navigator.of(context).pop();

      if (widget.shouldPop) {
        // Leave current page
        Navigator.of(context).pop();
      }
    }, onError: (messageKey) {
      context.showLocalizedSnackBar(messageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      initialData: false,
      stream: _viewModel.onLoading,
      builder: (bool isLoading) => AsyncAlertDialog(
        title: Text("delete_upload").t(context),
        content: Text("delete_upload_confirmation")
            .t(context, arguments: {"filename": widget.upload.filename!}),
        isProcessing: isLoading,
        onSubmitted: () =>
            _viewModel.delete(widget.upload.projectId!, widget.upload.id!),
      ),
    );
  }
}
