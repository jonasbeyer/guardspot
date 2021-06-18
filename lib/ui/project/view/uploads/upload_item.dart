import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/project/view/common/share/share_model_dialog.dart';
import 'package:guardspot/ui/project/view/uploads/delete/delete_upload_dialog.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class UploadItem extends StatelessWidget {
  final Upload upload;

  UploadItem(this.upload);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () => AutoRouter.of(context).push(UploadScreenRoute(
        projectId: upload.projectId!,
        uploadId: upload.id!,
      )),
      child: FlatCard(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UploadPreview(upload),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upload.filename!,
                    style: TextStyle(fontSize: 17.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "date_time_medium",
                    style: TextStyle(
                      fontSize: 14.5,
                      color: AppColors.textColorSecondary(themeData),
                    ),
                  ).t(context, arguments: {"date": upload.createdAt!}),
                ],
              ),
            ),
            UploadActionsButton(upload),
          ],
        ),
      ),
    );
  }
}

class UploadPreview extends StatelessWidget {
  final Upload upload;

  UploadPreview(this.upload);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      width: 100,
      height: 70,
      child: Center(
        child: upload.previewUrl != null
            ? Image.network(upload.previewUrl!)
            : Text(
                upload.filename!.split(".").last.toUpperCase(),
                style: TextStyle(fontSize: 18.0, color: Colors.white60),
              ),
      ),
    );
  }
}

class UploadActionsButton extends StatelessWidget {
  final Upload upload;
  final bool singleScreen;

  UploadActionsButton(this.upload, {this.singleScreen = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => showDialog(
        context: context,
        builder: (_) {
          switch (value) {
            case 0:
              return Container();
            case 1:
              return ShareModelDialog(upload);
            default:
              return DeleteUploadDialog(upload, shouldPop: singleScreen);
          }
        },
      ),
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(child: Text("download").t(context), value: 0),
        PopupMenuItem(child: Text("share").t(context), value: 1),
        PopupMenuItem(child: Text("delete").t(context), value: 2),
      ],
    );
  }
}
