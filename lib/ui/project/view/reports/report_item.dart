import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/common/widgets/actions_button.dart';
import 'package:guardspot/ui/project/view/common/share/share_model_dialog.dart';
import 'package:guardspot/ui/project/view/reports/delete/delete_report_dialog.dart';
import 'package:guardspot/ui/project/view/reports/add_edit/add_edit_report_dialog.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ReportItem extends StatelessWidget {
  final Report report;

  ReportItem(this.report);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AutoRouter.of(context).push(ReportScreenRoute(
        projectId: report.projectId!,
        reportId: report.id!,
      )),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(report.user!, style: UserAvatarStyle.small()),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.user!.name!,
              style: themeData.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              context.getString("date_time_long", arguments: {
                "date": report.createdAt!,
              }),
              style: TextStyle(color: AppColors.textColorSecondary(themeData)),
            ),
          ],
        ),
        ReportActionsButton(report),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      report.message!,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ReportActionsButton extends StatelessWidget {
  final Report report;

  ReportActionsButton(this.report);

  @override
  Widget build(BuildContext context) {
    return ActionsButton(
      items: [
        ActionsButtonItem(
          child: Text("share").t(context),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ShareModelDialog(report),
          ),
        ),
        ActionsButtonItem(
          child: Text("edit").t(context),
          onPressed: () =>
              showAddEditReportInput(context: context, report: report),
        ),
        ActionsButtonItem(
          child: Text("delete").t(context),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => DeleteReportDialog(report),
          ),
        ),
      ],
    );
  }
}
