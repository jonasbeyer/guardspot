import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/project_details_view_model.dart';
import 'package:guardspot/ui/project/view/uploads/add/upload_file_dialog.dart';
import 'package:guardspot/ui/project/view/uploads/upload_item.dart';
import 'package:guardspot/ui/project/view/uploads/uploads_view_model.dart';
import 'package:provider/provider.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class UploadsScreen extends StatefulWidget {
  @override
  _UploadsScreenState createState() => _UploadsScreenState();
}

class _UploadsScreenState extends State<UploadsScreen> {
  late UploadsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel
        .setProjectId(context.read<ProjectDetailsViewModel>().getProjectId());
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TypedStreamBuilder(
        stream: _viewModel.data,
        errorWidget: ContentLoadingNetworkError(),
        builder: (List<Upload> uploadedFiles) => uploadedFiles.isEmpty
            ? _buildPlaceholder()
            : _buildFilesList(uploadedFiles),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_upload_fab",
        child: Icon(Icons.file_upload),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => UploadFileDialog(
            projectId: context.read<ProjectDetailsViewModel>().getProjectId(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() => ContentLoadingError(
        icon: Icon(Icons.insert_drive_file),
        message: Text("no_uploads_hint").t(context),
      );

  Widget _buildFilesList(List<Upload> files) {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: files.length,
      itemBuilder: (_, position) => UploadItem(files[position]),
      separatorBuilder: (_, position) => SizedBox(height: 15),
    );
  }
}
