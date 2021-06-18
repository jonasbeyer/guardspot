import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/common/comment/delete/delete_comment_view_model.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class DeleteCommentDialog extends StatefulWidget {
  final Comment comment;

  DeleteCommentDialog(this.comment);

  @override
  _DeleteCommentDialogState createState() => _DeleteCommentDialogState();
}

class _DeleteCommentDialogState extends State<DeleteCommentDialog> {
  late DeleteCommentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("comment_deleted");
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
        title: Text("delete_comment").t(context),
        content: Text("delete_comment_confirmation").t(context),
        onSubmitted: () => _viewModel.delete(widget.comment),
        isProcessing: isLoading,
      ),
    );
  }
}
