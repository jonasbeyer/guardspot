import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/recording.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/link_sharing/link_sharing_view_model.dart';
import 'package:guardspot/ui/project/view/reports/view/report_screen.dart';
import 'package:guardspot/ui/project/view/uploads/view/upload_screen.dart';

class LinkSharingScreen extends StatefulWidget {
  final String secret;

  LinkSharingScreen({
    @pathParam required this.secret,
  });

  @override
  _LinkSharingScreenState createState() => _LinkSharingScreenState();
}

class _LinkSharingScreenState extends State<LinkSharingScreen> {
  late PublicSharingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.loadRessource(widget.secret);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TypedStreamBuilder(
        stream: _viewModel.data,
        builder: (Recording recording) {
          switch (recording.type) {
            case "upload":
              return ViewUpload(Upload.fromJson(recording.data));
            case "report":
              return ViewReport(Report.fromJson(recording.data));
            default:
              return Container();
          }
        },
      ),
    );
  }
}
