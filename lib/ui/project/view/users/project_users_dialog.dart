import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/project/view/users/project_users_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ProjectUsersDialog extends StatefulWidget {
  final Project project;

  ProjectUsersDialog(this.project);

  @override
  _ManageUsersDialogState createState() => _ManageUsersDialogState();
}

class _ManageUsersDialogState extends State<ProjectUsersDialog> {
  late ProjectUsersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setProject(widget.project);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("manage_project_members").t(context),
      contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      scrollable: true,
      content: Container(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text("manage_project_members_description").t(context),
            ),
            Divider(height: 25),
            TypedStreamBuilder(
              stream: _viewModel.memberships,
              builder: (List<ProjectMembership> memberships) => Column(
                children: memberships.map(_buildMemberTile).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(ProjectMembership membership) {
    return ListTile(
      title: Text(membership.user.name!),
      leading: UserAvatar(
        membership.user,
        style: UserAvatarStyle.small(),
      ),
      trailing:
          membership.isProjectMember ? Icon(Icons.check, size: 20.0) : null,
      onTap: () => _viewModel.toggleMembership(membership),
      contentPadding: EdgeInsets.only(left: 24, right: 15),
      horizontalTitleGap: 10,
    );
  }
}
