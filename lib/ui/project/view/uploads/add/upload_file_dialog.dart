import 'package:dio/dio.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/ui/common/widgets/blocking_progress_indicator.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/uploads/add/upload_file_view_model.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';

class UploadFileDialog extends StatefulWidget {
  final int projectId;

  UploadFileDialog({required this.projectId});

  @override
  _UploadFileDialogState createState() => _UploadFileDialogState();
}

class _UploadFileDialogState extends State<UploadFileDialog> {
  late UploadFileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("upload_saved");
    }, onError: (messageKey) {
      context.showLocalizedSnackBar(messageKey);
    });

    _openFileSelector();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      initialData: ViewState.initial(),
      stream: _viewModel.data,
      builder: (ViewState state) => state is ViewStateInitial
          ? Container()
          : AlertDialog(content: BlockingProgressIndicator()),
    );
  }

  Future<void> _openFileSelector() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      Navigator.of(context).pop();
      return;
    }

    // the file's content type is determined on the server-side
    final platformFile = result.files.single;
    final multipartFile = MultipartFile.fromBytes(
      platformFile.bytes!,
      filename: platformFile.name,
    );

    _viewModel.upload(widget.projectId, multipartFile);
  }
}
