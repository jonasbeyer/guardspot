import 'package:injectable/injectable.dart';
import 'package:guardspot/data/upload/upload_service.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class UploadScreenViewModel extends BaseViewModel<Upload> {
  final UploadService _uploadService;

  UploadScreenViewModel(this._uploadService);

  void loadUpload(int projectId, int uploadId) {
    _uploadService
        .getUpload(projectId, uploadId)
        .then((upload) => emit(upload))
        .catchError((error) => emitFailure(error));
  }
}
