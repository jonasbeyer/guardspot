import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/widgets/add_edit_scaffold.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/reports/add_edit/add_edit_report_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';

void showAddEditReportInput({
  required BuildContext context,
  int? projectId,
  Report? report,
}) {
  showAdaptiveInput(
    context: context,
    dialogWidget: AddEditReportDialog(
      projectId: projectId,
      report: report,
      fullscreen: !isDisplayDesktop(context),
    ),
  );
}

class AddEditReportDialog extends StatefulWidget {
  final int? projectId;
  final Report? report;
  final bool fullscreen;

  AddEditReportDialog({
    this.projectId,
    this.report,
    this.fullscreen = true,
  }) : assert(projectId != null || report != null);

  @override
  _AddEditReportDialogState createState() => _AddEditReportDialogState();
}

class _AddEditReportDialogState extends State<AddEditReportDialog> {
  late AddEditReportViewModel _viewModel;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.initialReport
        .add(widget.report ?? Report(projectId: widget.projectId!));
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("report_saved");
    }, onError: (messageKey) {
      context.showLocalizedSnackBar(messageKey);
    });

    _controller = TextEditingController(text: widget.report?.message);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      initialData: false,
      stream: _viewModel.onLoading,
      builder: (bool isLoading) => widget.fullscreen
          ? _buildScaffold(isLoading)
          : _buildDialog(isLoading),
    );
  }

  Widget _buildDialog(bool isLoading) {
    return AsyncAlertDialog(
      isProcessing: isLoading,
      isSubmittable: _controller.text.isNotEmpty,
      onSubmitted: () => _viewModel.submitReport(_controller.text),
      title: Text(widget.report == null ? "create_report" : "edit_report")
          .t(context),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(border: UnderlineInputBorder()),
          ),
          SizedBox(height: 15),
          TextButton.icon(
            onPressed: _openFileSelector,
            icon: Icon(Icons.attach_file),
            label: Text("Anhang hinzufügen"),
          ),
          TypedValueStreamBuilder(
            stream: _viewModel.images,
            builder: (List<PlatformFile> files) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  files.map((PlatformFile file) => Attachment(file)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(bool isLoading) {
    return AddEditScaffold(
      title: context
          .getString(widget.report == null ? "create_report" : "edit_report"),
      onSavePressed: () => _viewModel.submitReport(_controller.text),
      isSaving: isLoading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: null,
            style: TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Beschreiben Sie Ihre Meldung",
            ),
          ),
          SizedBox(height: 20),
          TypedStreamBuilder(
            initialWidget: Container(),
            stream: _viewModel.images,
            builder: (List<PlatformFile> files) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: files
                  .map((PlatformFile file) => Image.file(File(file.path!)))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !kIsWeb,
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: _selectImage,
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    CameraCamera camera = CameraCamera(
      resolutionPreset: ResolutionPreset.veryHigh,
      onFile: (file) async {
        Navigator.pop(context);
        PlatformFile platformFile = PlatformFile(
          path: file.path,
          bytes: await file.readAsBytes(),
          name: "image",
        );

        _viewModel.addImages([platformFile]);
      },
    );

    await Navigator.push(context, MaterialPageRoute(builder: (_) => camera));
  }

  Future<void> _openFileSelector() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      _viewModel.addImages(result.files);
    }
  }
}

class Attachment extends StatelessWidget {
  final PlatformFile file;

  Attachment(this.file);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(file.name!),
      ],
    );
  }
}
