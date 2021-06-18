import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/schedule/delete/delete_schedule_entry_view_model.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class DeleteScheduleEntryDialog extends StatefulWidget {
  final ScheduleEntry scheduleEntry;

  DeleteScheduleEntryDialog(this.scheduleEntry);

  @override
  _DeleteScheduleEntryDialogState createState() =>
      _DeleteScheduleEntryDialogState();
}

class _DeleteScheduleEntryDialogState extends State<DeleteScheduleEntryDialog> {
  late DeleteScheduleEntryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("schedule_entry_deleted");
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
        title: Text("delete_schedule_entry").t(context),
        content: Text("delete_schedule_entry_confirmation").t(context),
        onSubmitted: () => _viewModel.delete(widget.scheduleEntry),
        isProcessing: isLoading,
      ),
    );
  }
}
