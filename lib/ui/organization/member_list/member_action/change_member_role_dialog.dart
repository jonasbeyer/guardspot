import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/widgets/blocking_progress_indicator.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/organization/member_list/member_list_view_model.dart';
import 'package:guardspot/util/enum_util.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';

class ChangeMemberRoleDialog extends StatefulWidget {
  final User user;
  final MemberListViewModel viewModel;
  final bool isOnlyAdmin;

  ChangeMemberRoleDialog({
    required this.user,
    required this.viewModel,
    this.isOnlyAdmin = false,
  });

  @override
  _ChangeMemberRoleDialogState createState() => _ChangeMemberRoleDialogState();
}

class _ChangeMemberRoleDialogState extends State<ChangeMemberRoleDialog> {
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
    return TypedStreamBuilder(
      initialData: false,
      stream: widget.viewModel.onLoading,
      builder: (bool isLoading) => AlertDialog(
        title: Text("team_member_change_role").t(context),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
        content: isLoading
            ? BlockingProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  width: 400,
                  child: _buildRoleList(UserRole.values),
                ),
              ),
      ),
    );
  }

  Widget _buildRoleList(List<UserRole> roles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...roles.map(_buildListTile),
        if (widget.isOnlyAdmin)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Text("one_admin_required").t(context),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildListTile(UserRole role) {
    bool isSelected = widget.user.role == role;
    bool isDisabled = widget.isOnlyAdmin && role != UserRole.ADMIN;

    return ListTile(
      title: _CheckableText(
        context.getString("user_role.${asName(role)}"),
        isChecked: isSelected,
      ),
      subtitle: Text("user_role_description.${asName(role)}").t(context),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      enabled: !isDisabled,
      onTap: () => isDisabled
          ? null
          : widget.viewModel.updateMemberRole(widget.user.id!, role),
    );
  }
}

class _CheckableText extends StatelessWidget {
  final String text;
  final bool isChecked;

  _CheckableText(this.text, {this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: text),
        if (isChecked)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(Icons.check, size: 16.0),
            ),
          ),
      ],
    ));
  }
}
