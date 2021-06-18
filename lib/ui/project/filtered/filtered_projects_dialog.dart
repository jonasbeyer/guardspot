import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/project/filtered/filtered_projects_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:guardspot/util/layout/adaptive.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class FilteredProjectsDialog extends StatefulWidget {
  static show(BuildContext context, ProjectsFilter filter) {
    showAdaptiveInput(
      context: context,
      dialogWidget: FilteredProjectsDialog(
        filter: filter,
        fullscreen: !isDisplayDesktop(context),
      ),
    );
  }

  final ProjectsFilter filter;
  final bool fullscreen;

  FilteredProjectsDialog({
    required this.filter,
    this.fullscreen = true,
  });

  @override
  _FilteredProjectsDialogState createState() => _FilteredProjectsDialogState();
}

class _FilteredProjectsDialogState extends State<FilteredProjectsDialog> {
  late FilteredProjectsDialogViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setFilter(widget.filter);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Text title = widget.filter == ProjectsFilter.ARCHIVED
        ? Text("archived_projects").t(context)
        : Text("inaccessible_projects").t(context);
    return StreamBuilder(
      stream: _viewModel.data,
      builder: (_, AsyncSnapshot<List<Project>> snapshot) {
        return widget.fullscreen
            ? Scaffold(
                appBar: AppBar(title: title),
                body: _buildContent(snapshot),
              )
            : AlertDialog(
                title: title,
                content: Container(
                  width: widget.filter == ProjectsFilter.ARCHIVED ? 600 : 400,
                  child: _buildContent(snapshot),
                ),
              );
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<List<Project>> snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    } else {
      List<Project> projects = snapshot.data!;
      return snapshot.data!.isEmpty
          ? widget.filter == ProjectsFilter.ARCHIVED
              ? Text("no_archived_projects").t(context)
              : Text("no_inaccessible_projects").t(context)
          : ListView.separated(
              shrinkWrap: true,
              padding: widget.fullscreen ? EdgeInsets.all(16.0) : null,
              separatorBuilder: (context, index) => Divider(height: 25),
              itemCount: projects.length,
              itemBuilder: (context, index) => _buildEntry(projects[index]),
            );
    }
  }

  Widget _buildEntry(Project project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: widget.filter == ProjectsFilter.INACCESSIBLE
              ? Text(project.name!)
              : _ArchivedTitle(
                  title: project.name!,
                  onClicked: () => context.router
                      .push(ProjectDetailsScreenRoute(id: project.id!)),
                ),
        ),
        widget.filter == ProjectsFilter.ARCHIVED
            ? _ArchivedActions(
                onDelete: () => _viewModel.deleteProject(project),
                onRestore: () => _viewModel.restoreProject(project),
              )
            : OutlinedButton.icon(
                icon: Icon(Icons.add),
                label: Text("add_me_to_project").t(context),
                onPressed: () => _viewModel.addMeToProject(project),
              )
      ],
    );
  }
}

class _ArchivedTitle extends StatelessWidget {
  final String title;
  final VoidCallback onClicked;

  _ArchivedTitle({
    required this.title,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClicked,
        child: Text(
          title,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}

class _ArchivedActions extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onRestore;

  _ArchivedActions({
    required this.onDelete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          icon: Icon(Icons.close),
          label: Text("delete").t(context),
          onPressed: onDelete,
          style: OutlinedButton.styleFrom(
            primary: Colors.redAccent,
            side: BorderSide(color: Colors.redAccent, width: 1),
          ),
        ),
        SizedBox(width: 10),
        OutlinedButton.icon(
          icon: Icon(Icons.restore),
          label: Text("restore").t(context),
          onPressed: onRestore,
        ),
      ],
    );
  }
}
