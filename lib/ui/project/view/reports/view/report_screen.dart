import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/project/view/common/comment/comment_section.dart';
import 'package:guardspot/ui/project/view/reports/report_item.dart';
import 'package:guardspot/ui/project/view/reports/view/report_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ReportScreen extends StatefulWidget {
  final int projectId;
  final int reportId;

  ReportScreen({
    @pathParam required this.projectId,
    @pathParam required this.reportId,
  });

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late ReportViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.loadReport(widget.projectId, widget.reportId);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _viewModel.data,
      builder: (_, AsyncSnapshot<Report> snapshot) {
        Report? report = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text("Meldung"),
            leading: BackButton(
              onPressed: () => context.router
                  .navigate(ProjectDetailsScreenRoute(id: widget.projectId)),
            ),
            actions: snapshot.hasData
                ? [
                    ReportActionsButton(snapshot.data!),
                  ]
                : null,
          ),
          body: !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : Scrollbar(
                  isAlwaysShown: kIsWeb,
                  child: _buildBody(report!),
                ),
        );
      },
    );
  }

  Widget _buildBody(Report report) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: AdaptiveInputBody(
        width: 700,
        margin: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewReport(report),
            Divider(height: 40),
            CommentSection(report),
          ],
        ),
      ),
    );
  }
}

class ViewReport extends StatelessWidget {
  final Report report;

  ViewReport(this.report);

  @override
  Widget build(BuildContext context) {
    return FlatCard(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 15),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(report.user!, style: UserAvatarStyle.medium()),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              report.user!.name!,
              style: themeData.textTheme.bodyText1!
                  .copyWith(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
            SelectableText(
              context.getString("date_time_long",
                  arguments: {"date": report.createdAt!}),
              style: TextStyle(color: AppColors.textColorSecondary(themeData)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          report.message!,
          style: TextStyle(fontSize: 18.0),
        ),
        if (report.attachments?.isNotEmpty == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              for (final attachment in report.attachments!)
                Image.network(attachment.downloadUrl),
            ],
          ),
      ],
    );
  }
}
