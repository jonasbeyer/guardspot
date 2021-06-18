import 'package:injectable/injectable.dart';
import 'package:guardspot/data/upload/upload_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class DeleteUploadViewModel extends ViewStateViewModel {
  final UploadService _uploadService;

  DeleteUploadViewModel(this._uploadService);

  Future<void> delete(int projectId, int uploadId) async {
    emitLoading();
    try {
      await _uploadService.deleteUpload(projectId, uploadId);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
