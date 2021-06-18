import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/reports/delete/delete_report_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';

class DeleteReportDialog extends StatefulWidget {
  final Report report;

  DeleteReportDialog(this.report);

  @override
  _DeleteReportDialogState createState() => _DeleteReportDialogState();
}

class _DeleteReportDialogState extends State<DeleteReportDialog> {
  late DeleteReportViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("report_deleted");
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
        title: Text("delete_report").t(context),
        content: Text("delete_report_confirmation").t(context),
        isProcessing: isLoading,
        onSubmitted: () => _viewModel.delete(
          widget.report.projectId!,
          widget.report.id!,
        ),
      ),
    );
  }
}
