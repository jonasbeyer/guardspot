import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/project/add_edit/add_edit_project_screen.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/filtered/filtered_projects_dialog.dart';
import 'package:guardspot/ui/project/project_list_item.dart';
import 'package:guardspot/ui/project/project_list_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';

class ProjectListScreen extends StatefulWidget {
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen>
    with AutomaticKeepAliveClientMixin {
  late ProjectListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.loadProjects();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: TypedStreamBuilder(
        stream: _viewModel.filteredProjects,
        errorWidget: ContentLoadingNetworkError(onRetry: _viewModel.retry),
        builder: (List<Project> projectList) => projectList.isEmpty
            ? _buildEmptyMessage()
            : _buildContent(projectList),
      ),
      floatingActionButton: Visibility(
        visible: !isDisplayDesktop(context),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showAddEditProjectInput(context),
        ),
      ),
    );
  }

  Widget _buildContent(List<Project> projects) {
    return isDisplayDesktop(context)
        ? _buildLargeScreen(projects)
        : _buildSmallScreen(projects);
  }

  Widget _buildLargeScreen(List<Project> projects) {
    ThemeData themeData = Theme.of(context);
    return Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        padding: adaptivePadding(context),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.getString("your_projects"),
                style: TextStyles.primaryTitle(themeData),
              ),
              SizedBox(height: 10),
              Container(
                width: 400,
                child: TextField(
                  onChanged: _viewModel.setQuery,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: context.getString("search_for_project"),
                    contentPadding: EdgeInsets.all(8.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              Divider(height: 30),
              _ProjectActions(),
              SizedBox(height: 15),
              Wrap(
                spacing: 15.0,
                runSpacing: 15.0,
                children: projects
                    .map((project) => SizedBox(
                          width: 300,
                          height: 150,
                          child: ProjectCard(project),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallScreen(List<Project> projects) {
    return Scrollbar(
      isAlwaysShown: kIsWeb,
      child: ListView.separated(
        padding: adaptivePadding(context),
        itemBuilder: (context, i) => ProjectCard(projects[i]),
        separatorBuilder: (_, i) => SizedBox(height: 20),
        itemCount: projects.length,
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return ContentLoadingError(
      title: Text("no_assigned_projects").t(context),
      message: Text("no_assigned_projects_description").t(context),
      button: ElevatedButton(
        child: Text("show_inaccessible_projects").t(context),
        onPressed: () =>
            FilteredProjectsDialog.show(context, ProjectsFilter.INACCESSIBLE),
      ),
    );
  }
}

class _ProjectActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text("show_inaccessible_projects").t(context),
          onPressed: () =>
              FilteredProjectsDialog.show(context, ProjectsFilter.INACCESSIBLE),
        ),
        Text("|"),
        TextButton(
          child: Text("show_archived_projects").t(context),
          onPressed: () =>
              FilteredProjectsDialog.show(context, ProjectsFilter.ARCHIVED),
        )
      ],
    );
  }
}
