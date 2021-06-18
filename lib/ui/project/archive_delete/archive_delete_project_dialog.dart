import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/archive_delete/archive_delete_project_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';

class ArchiveDeleteProjectDialog extends StatefulWidget {
  final Project project;

  ArchiveDeleteProjectDialog(this.project);

  @override
  _DeleteProjectDialogState createState() => _DeleteProjectDialogState();
}

class _DeleteProjectDialogState extends State<ArchiveDeleteProjectDialog> {
  late ArchiveDeleteProjectViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((route) {
      _doOnSuccess(route);
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
      builder: (bool isLoading) => AlertDialog(
        title: Text("archive_or_delete_project").t(context),
        content: SizedBox(
          width: 450,
          child: Text("archive_or_delete_project_description")
              .t(context, arguments: {"title": widget.project.name!}),
        ),
        actions: [
          ElevatedButton(
            child: Text(context.getString("archive").toUpperCase()),
            onPressed: () =>
                isLoading ? null : _viewModel.archive(widget.project),
          ),
          OutlinedButton(
            child: Text(context.getString("delete").toUpperCase()),
            onPressed: () =>
                isLoading ? null : _viewModel.delete(widget.project),
            style: OutlinedButton.styleFrom(
              primary: Colors.redAccent,
              side: BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _doOnSuccess(PageRouteInfo? result) {
    if (result != null) {
      AutoRouter.of(context).navigate(result);
    } else {
      Navigator.of(context).pop();
    }
  }
}
