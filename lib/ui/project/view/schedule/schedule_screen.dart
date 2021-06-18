import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/project/view/project_details_view_model.dart';
import 'package:guardspot/ui/project/view/schedule/add_edit/add_edit_schedule_entry_dialog.dart';
import 'package:guardspot/ui/project/view/schedule/schedule_view_model.dart';
import 'package:guardspot/ui/schedule/schedule_screen.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleViewModel _viewModel;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.loadScheduleEntries(
        context.read<ProjectDetailsViewModel>().getProjectId());
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewSchedule(
        scheduleEntries: _viewModel.data,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_schedule_entry_fab",
        child: Icon(Icons.calendar_today),
        onPressed: () => showAddEditScheduleEntryInput(
          context: context,
          project: context.read<ProjectDetailsViewModel>().state!,
        ),
      ),
    );
  }
}
