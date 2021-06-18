import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/ui/user/user_view_model_delegate.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class UserSignOutDialog extends StatefulWidget {
  final UserViewModelDelegate viewModel;

  UserSignOutDialog(this.viewModel);

  @override
  _UserSignOutDialogState createState() => _UserSignOutDialogState();
}

class _UserSignOutDialogState extends State<UserSignOutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("sign_out").t(context),
      content: Text("confirm_sign_out").t(context),
      actions: [
        TextButton(
          child: Text(context.getString("cancel").toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(context.getString("sign_out").toUpperCase()),
          onPressed: () => _signOut(),
        ),
      ],
    );
  }

  void _signOut() {
    widget.viewModel.signOut();
    AutoRouter.of(context)
        .pushAndPopUntil(SignInScreenRoute(), predicate: (_) => false);
  }
}
