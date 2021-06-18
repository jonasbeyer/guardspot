import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/project/add_edit/add_edit_project_screen.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/project/archive_delete/archive_delete_project_dialog.dart';
import 'package:guardspot/ui/project/view/project_details_view_model.dart';
import 'package:guardspot/ui/project/view/users/project_users_dialog.dart';
import 'package:guardspot/ui/project/project_list_item.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/maps_util.dart';
import 'package:provider/provider.dart';

class ProjectInfoScreen extends StatefulWidget {
  final bool embedded;
  final bool shrinkWrap;
  final EdgeInsets padding;

  ProjectInfoScreen({this.embedded = false})
      : this.padding = embedded ? EdgeInsets.zero : EdgeInsets.all(16.0),
        this.shrinkWrap = embedded;

  @override
  _ProjectInfoScreenState createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen>
    with AutomaticKeepAliveClientMixin {
  late ProjectDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.embedded
        ? _buildBody()
        : Scaffold(
            body: _buildBody(),
            floatingActionButton: FloatingActionButton(
              heroTag: "navigate_fab",
              child: Icon(Icons.navigation),
              onPressed: () =>
                  MapsUtil.startNavigation(_viewModel.state!.location!),
            ),
          );
  }

  Widget _buildBody() {
    ThemeData themeData = Theme.of(context);
    TextStyle titleStyle =
        themeData.textTheme.headline5!.copyWith(fontSize: 21.0);
    TextStyle bodyStyle =
        themeData.textTheme.bodyText2!.copyWith(fontSize: 16.0);

    return TypedValueStreamBuilder(
      stream: _viewModel.data,
      errorWidget: Container(),
      initialWidget: Container(),
      builder: (Project? project) => DefaultTextStyle(
        style: bodyStyle,
        child: ListView(
          shrinkWrap: widget.shrinkWrap,
          padding: widget.padding,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectableText(project!.name!, style: titleStyle),
                SizedBox(height: 1),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10.0,
                  children: [
                    SelectableText(
                      context.getString("date_time_medium",
                              arguments: {"date": project.createdAt!}) +
                          " • " +
                          "Aktuell ${project.nearbyUsersCount} Mitarbeiter in der Nähe",
                      style: TextStyle(
                        color: AppColors.textColorSecondary(themeData),
                        fontSize: 15.0,
                      ),
                    ),
                    _ProjectActions(project),
                  ],
                ),
              ],
            ),
            Divider(height: 10),
            SizedBox(height: 10),
            ProjectUsers(
              project,
              avatarStyle: UserAvatarStyle.small(),
              compact: false,
            ),
            SizedBox(height: 20),
            SelectableText(project.description ?? ""),
            Divider(height: 30),
            ProjectInfoGrid(project),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProjectActions extends StatelessWidget {
  final Project project;

  _ProjectActions(this.project);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        TextButton.icon(
          icon: Icon(Icons.people),
          label:
              Text(context.getString("project_members_choose").toUpperCase()),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ProjectUsersDialog(project),
          ),
        ),
        // TextButton.icon(
        //   icon: project.subscribed!
        //       ? Icon(Icons.notifications_off)
        //       : Icon(Icons.notifications_on),
        //   label: project.subscribed!
        //       ? Text("Entfolgen".toUpperCase())
        //       : Text("Folgen".toUpperCase()),
        //   onPressed: () => context
        //       .read<ProjectDetailsViewModel>()
        //       .updateSubscription(!project.subscribed!),
        // ),
        TextButton.icon(
          icon: Icon(Icons.edit),
          label: Text(context.getString("edit").toUpperCase()),
          onPressed: () => showAddEditProjectInput(context, project: project),
        ),
        TextButton.icon(
          icon: project.archived! ? Icon(Icons.delete) : Icon(Icons.archive),
          label: project.archived!
              ? Text(context.getString("delete").toUpperCase())
              : Text(context.getString("archive").toUpperCase()),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ArchiveDeleteProjectDialog(project),
          ),
        ),
      ],
    );
  }
}

class ProjectInfoGrid extends StatelessWidget {
  final Project project;

  ProjectInfoGrid(this.project);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 20.0,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              context.getString("project_general").toUpperCase(),
              style: TextStyles.sectionHeader(themeData),
            ),
            SizedBox(height: 12),
            SelectableText("${context.getString('date_time_medium', arguments: {
                  'date': project.createdAt!
                })}\n${project.users.length} Mitarbeiter zugwiesen\nIn Bearbeitung"),
          ],
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              context.getString("project_location").toUpperCase(),
              style: TextStyles.sectionHeader(themeData),
            ),
            SizedBox(height: 12),
            SelectableText(
              "${project.address!}\n${project.place}\n${project.countryCode}",
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              context.getString("project_client_information").toUpperCase(),
              style: TextStyles.sectionHeader(themeData),
            ),
            SizedBox(height: 12),
            SelectableText("${project.clientName!}\n${project.clientPhone!}"),
          ],
        ),
      ],
    );
  }
}
