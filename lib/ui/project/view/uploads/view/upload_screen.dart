import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:guardspot/ui/project/view/common/comment/comment_section.dart';
import 'package:guardspot/ui/project/view/uploads/upload_item.dart';
import 'package:guardspot/ui/project/view/uploads/view/upload_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class UploadScreen extends StatefulWidget {
  final int projectId;
  final int uploadId;

  UploadScreen({
    @pathParam required this.projectId,
    @pathParam required this.uploadId,
  });

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late UploadScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.loadUpload(widget.projectId, widget.uploadId);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BackButton button = BackButton(
      onPressed: () => context.router
          .navigate(ProjectDetailsScreenRoute(id: widget.projectId)),
    );
    return StreamBuilder(
      stream: _viewModel.data,
      builder: (_, AsyncSnapshot<Upload> snapshot) {
        Upload? upload = snapshot.data;
        return Scaffold(
          appBar: upload == null
              ? AppBar(leading: button)
              : AppBar(
                  centerTitle: true,
                  title: Text(upload.filename!),
                  leading: button,
                  actions: [
                    UploadActionsButton(upload, singleScreen: true),
                  ],
                ),
          body: Center(
            child: !snapshot.hasData
                ? CircularProgressIndicator()
                : Scrollbar(
                    isAlwaysShown: kIsWeb,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: AdaptiveInputBody(
                        width: 700,
                        margin: EdgeInsets.zero,
                        alignment: Alignment.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ViewUpload(upload!),
                            SizedBox(height: 15),
                            CommentSection(upload),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class ViewUpload extends StatelessWidget {
  final Upload upload;
  final bool showMetdata;

  ViewUpload(this.upload, {this.showMetdata = false});

  @override
  Widget build(BuildContext context) {
    return FlatCard(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              upload.downloadUrl!,
              errorBuilder: (_, __, ___) => ContentLoadingError(
                title: Text("no_preview_available").t(context),
                message: Text("no_preview_available_description").t(context),
              ),
              loadingBuilder: (_, image, loadingProgress) =>
                  loadingProgress == null ? image : CircularProgressIndicator(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                Text(
                  upload.filename!,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   "1,47 MB • 29.05.2021",
                    //   style: TextStyles.secondarySubtitle(Theme.of(context)),
                    // ),
                    // SizedBox(height: 5),
                    ElevatedButton(
                      child: Text(context.getString("download").toUpperCase()),
                      onPressed: () => null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
