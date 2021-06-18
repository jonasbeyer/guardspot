import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/async_alert_dialog.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/organization/edit/edit_organization_view_model.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class EditOrganizationDialog extends StatefulWidget {
  final String initialName;

  EditOrganizationDialog({required this.initialName});

  @override
  _EditOrganizationDialogState createState() => _EditOrganizationDialogState();
}

class _EditOrganizationDialogState extends State<EditOrganizationDialog> {
  late EditOrganizationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.name.add(widget.initialName);
    _viewModel.viewStateResult.listen((destination) {
      context.showLocalizedSnackBar("organization_edited");
      Navigator.of(context).pop();
    }, onError: (error) {
      context.showLocalizedSnackBar(error);
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
      builder: (bool isLoading) => TypedStreamBuilder(
        initialData: widget.initialName,
        stream: _viewModel.name,
        builder: (String name) => AsyncAlertDialog(
          isProcessing: isLoading,
          isSubmittable: name.isNotEmpty,
          onSubmitted: _viewModel.updateName,
          title: Text("edit_organization").t(context),
          content: TextFormField(
            initialValue: widget.initialName,
            onChanged: _viewModel.name.add,
            autofocus: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: context.getString("company_name"),
              helperText: context.getString("company_name_hint"),
              prefixIcon: Icon(Icons.people),
            ),
          ),
        ),
      ),
    );
  }
}
