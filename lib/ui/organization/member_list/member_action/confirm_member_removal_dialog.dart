import 'package:flutter/material.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/organization/member_list/member_list_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';

class ConfirmMemberRemovalDialog extends StatefulWidget {
  final User user;
  final MemberListViewModel viewModel;

  ConfirmMemberRemovalDialog({
    required this.user,
    required this.viewModel,
  });

  @override
  _ConfirmMemberRemovalDialogState createState() =>
      _ConfirmMemberRemovalDialogState();
}

class _ConfirmMemberRemovalDialogState
    extends State<ConfirmMemberRemovalDialog> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.viewStateResult.listen((event) {
      Navigator.of(context).pop();
    }, onError: (error) {
      context.showLocalizedSnackBar(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("team_member_remove").t(context),
      content: Text("team_member_confirm_removal")
          .t(context, arguments: {"name": widget.user.name!}),
      actions: [
        TextButton(
          child: Text(context.getString("cancel").toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(context.getString("ok").toUpperCase()),
          onPressed: () => widget.viewModel.removeMember(widget.user.email!),
        ),
      ],
    );
  }
}
