import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/project_details_view_model.dart';
import 'package:guardspot/ui/project/view/reports/report_item.dart';
import 'package:guardspot/ui/project/view/reports/reports_view_model.dart';
import 'package:guardspot/ui/project/view/reports/add_edit/add_edit_report_dialog.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ReportsViewModel _viewModel;
  late ProjectDetailsViewModel _projectDetailsViewModel;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _projectDetailsViewModel = context.read();
    _viewModel = locator();
    _viewModel.loadReports(_projectDetailsViewModel.getProjectId());

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TypedStreamBuilder(
        stream: _viewModel.data,
        errorWidget: ContentLoadingNetworkError(),
        builder: (List<Report> reportList) => reportList.isEmpty
            ? _buildEmptyMessage()
            : _buildReportList(reportList),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_report_fab",
        child: Icon(Icons.add),
        onPressed: () => showAddEditReportInput(
          context: context,
          projectId: _projectDetailsViewModel.getProjectId(),
        ),
      ),
    );
  }

  Widget _buildReportList(List<Report> reports) {
    return Scrollbar(
      isAlwaysShown: kIsWeb,
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(right: 10.0),
        itemCount: reports.length,
        itemBuilder: (context, index) => ReportItem(reports[index]),
      ),
    );
  }

  Widget _buildEmptyMessage() => ContentLoadingError(
        icon: Icon(Icons.message),
        message: Text("reports_not_found_description").t(context),
      );
}
