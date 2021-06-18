import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/organization/member_list/member_action/change_member_role_dialog.dart';
import 'package:guardspot/ui/organization/member_list/member_action/confirm_member_removal_dialog.dart';
import 'package:guardspot/ui/organization/member_list/member_list_view_model.dart';
import 'package:guardspot/ui/user/user_view_model_delegate.dart';
import 'package:guardspot/util/enum_util.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';
import 'package:provider/provider.dart';

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late MemberListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.fetchMembers();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _viewModel,
      child: TypedStreamBuilder(
        stream: _viewModel.users,
        builder: (List<User> users) => SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: _MembersList(
            users: users,
            onMemberFilterChanged: _viewModel.changeNameFilter,
          ),
        ),
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List<User> users;
  final int adminCount;

  final ValueSetter<String>? onMemberFilterChanged;
  final UserViewModelDelegate userViewModel;

  _MembersList({
    required this.users,
    this.onMemberFilterChanged,
  })  : this.userViewModel = locator(),
        this.adminCount =
            users.where((user) => user.role == UserRole.ADMIN).length;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("team_members_title", style: themeData.textTheme.headline5)
            .t(context, arguments: {"count": users.length}),
        SizedBox(height: 15),
        Text("team_member_access_hint").t(context),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: 275,
            child: TextField(
              onChanged: this.onMemberFilterChanged,
              decoration: InputDecoration(
                hintText: context.getString("team_member_search_hint"),
                isDense: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
          ),
        ),
        Divider(height: 50),
        TypedValueStreamBuilder(
          stream: userViewModel.currentUserInfo,
          builder: (User? currentUser) => Column(
            children: users
                .map((user) => _MembershipUser(
                      user: user,
                      currentUser: currentUser!,
                      isOnlyAdmin:
                          user.role == UserRole.ADMIN && adminCount == 1,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class _MembershipUser extends StatelessWidget {
  final User user;
  final User currentUser;
  final bool isOnlyAdmin;

  _MembershipUser({
    required this.user,
    required this.currentUser,
    required this.isOnlyAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return isDisplayDesktop(context)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: _buildUserInfo(context)),
              Expanded(flex: 4, child: _buildActions(context)),
            ],
          )
        : FlatCard(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(context),
                _buildActions(context),
              ],
            ),
          );
  }

  Widget _buildUserInfo(BuildContext context) {
    return ListTile(
      title: Text(user.name!),
      subtitle: Text(context.getString("user_role.${asName(user.role)}")),
      contentPadding: EdgeInsets.zero,
      leading: UserAvatar(user),
    );
  }

  Widget _buildActions(BuildContext context) {
    bool isAdmin = currentUser.hasRole(UserRole.ADMIN);
    bool isMe = currentUser.id == user.id;
    return Row(
      children: [
        OutlinedButton(
          child: Text("team_member_change_role").t(context),
          onPressed: !isAdmin
              ? null
              : () => showDialog(
                    context: context,
                    builder: (_) => ChangeMemberRoleDialog(
                      user: user,
                      viewModel: context.read(),
                      isOnlyAdmin: isOnlyAdmin,
                    ),
                  ),
        ),
        SizedBox(width: 12),
        OutlinedButton.icon(
          icon: Icon(Icons.close),
          label: Text(isMe ? "leave" : "remove").t(context),
          onPressed: isOnlyAdmin
              ? null
              : () => showDialog(
                    context: context,
                    builder: (_) => ConfirmMemberRemovalDialog(
                      user: user,
                      viewModel: context.read<MemberListViewModel>(),
                    ),
                  ),
        )
      ],
    );
  }
}
