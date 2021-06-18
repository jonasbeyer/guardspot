import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/dimens.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/widgets/destination.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/map/location_map.dart';
import 'package:guardspot/ui/common/widgets/sliver_app_bar_delegate.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/info/project_info_screen.dart';
import 'package:guardspot/ui/project/view/project_details_view_model.dart';
import 'package:guardspot/ui/project/view/reports/reports_screen.dart';
import 'package:guardspot/ui/project/view/schedule/schedule_screen.dart';
import 'package:guardspot/ui/project/view/uploads/uploads_screen.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';
import 'package:provider/provider.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final int id;

  const ProjectDetailsScreen({@pathParam required this.id});

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late ProjectDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setProjectId(widget.id);
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
      child: isDisplayDesktop(context)
          ? _ProjectDetailsScreenLarge()
          : _ProjectDetailsScreenSmall(),
    );
  }
}

class _ProjectDetailsScreenLarge extends StatefulWidget {
  final List<Destination> tabs = [
    Destination(titleKey: "title_project_reports", widget: ReportsScreen()),
    Destination(titleKey: "title_project_schedule", widget: ScheduleScreen()),
    Destination(titleKey: "title_project_files", widget: UploadsScreen())
  ];

  @override
  __ProjectDetailsScreenLargeState createState() =>
      __ProjectDetailsScreenLargeState();
}

class __ProjectDetailsScreenLargeState
    extends State<_ProjectDetailsScreenLarge> {
  @override
  Widget build(BuildContext context) {
    bool largeDesktop = isDisplayLargeDesktop(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("title_project_detail").t(context),
        leading: BackButton(
          onPressed: () => context.router.navigate(DashboardScreenRoute()),
        ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: AppDimens.verticalPaddingDesktop,
            bottom: AppDimens.verticalPaddingDesktop,
            left: largeDesktop ? 250 : 30,
            right: largeDesktop ? 250 : 50,
          ),
          child: StreamBuilder(
            stream: context.read<ProjectDetailsViewModel>().data,
            builder: (_, AsyncSnapshot<Project?> snapshot) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 13,
                  child: _buildMainColumn(context, snapshot),
                ),
                SizedBox(width: 25),
                Expanded(
                  flex: 6,
                  child: snapshot.hasData
                      ? _buildSideColumn(
                          context: context,
                          project: snapshot.data!,
                          height: largeDesktop ? 700 : 600,
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainColumn(
    BuildContext context,
    AsyncSnapshot<Project?> snapshot,
  ) {
    Project? project = snapshot.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: project == null
              ? ProjectNotAvailable(hasError: snapshot.hasError)
              : LocationMap(
                  project.location!,
                  users: project.getNearbyUsers(),
                  interactive: true,
                ),
        ),
        SizedBox(height: 16),
        ProjectInfoScreen(embedded: true),
      ],
    );
  }

  Widget _buildSideColumn({
    required BuildContext context,
    required Project project,
    double height = 600,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (project.archived!)
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: ProjectArchived(),
          ),
        DefaultTabController(
          length: widget.tabs.length,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[900],
                  child: TabBar(
                    tabs: widget.tabs
                        .map((it) => Tab(
                            text: context.getString(it.titleKey).toUpperCase()))
                        .toList(),
                  ),
                ),
                Divider(height: 0),
                Container(
                  height: height,
                  child: TabBarView(
                    children: widget.tabs.map((it) => it.widget!).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectDetailsScreenSmall extends StatefulWidget {
  final List<Destination> tabs = [
    Destination(titleKey: "title_project_general", widget: ProjectInfoScreen()),
    Destination(titleKey: "title_project_reports", widget: ReportsScreen()),
    Destination(titleKey: "title_project_schedule", widget: ScheduleScreen()),
    Destination(titleKey: "title_project_files", widget: UploadsScreen())
  ];

  @override
  _ProjectDetailsScreenSmallState createState() =>
      _ProjectDetailsScreenSmallState();
}

class _ProjectDetailsScreenSmallState extends State<_ProjectDetailsScreenSmall>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TypedValueStreamBuilder(
        stream: context.read<ProjectDetailsViewModel>().data,
        builder: (Project? project) => SafeArea(
          child: DefaultTabController(
            length: widget.tabs.length,
            child: _buildNestedScrollView(project),
          ),
        ),
      ),
    );
  }

  Widget _buildNestedScrollView(Project? project) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          collapsedHeight: 200,
          elevation: 0.0,
          flexibleSpace: LocationMap(
            project!.location!,
            users: project.users,
            interactive: true,
          ),
        ),
        SliverPersistentHeader(
          floating: true,
          delegate: SliverAppBarDelegate(
            TabBar(
              isScrollable: true,
              tabs: widget.tabs
                  .map((it) =>
                      Tab(text: context.getString(it.titleKey).toUpperCase()))
                  .toList(),
            ),
          ),
        ),
      ],
      body: TabBarView(
        children: widget.tabs.map((it) => it.widget!).toList(),
      ),
    );
  }
}

class ProjectArchived extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: FlatCard(
        padding: EdgeInsets.all(12.0),
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("project_archived", style: TextStyle(fontSize: 15.0))
                .t(context),
            TextButton(
              child: Text("revert").t(context),
              onPressed: () =>
                  context.read<ProjectDetailsViewModel>().restoreProject(),
            )
          ],
        ),
      ),
    );
  }
}

class ProjectNotAvailable extends StatelessWidget {
  final bool hasError;

  ProjectNotAvailable({required this.hasError});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: Colors.grey[900],
      child: !hasError
          ? Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 140.0),
                SizedBox(width: 15),
                Text("project_not_found", style: themeData.textTheme.headline5)
                    .t(context),
              ],
            ),
    );
  }
}
