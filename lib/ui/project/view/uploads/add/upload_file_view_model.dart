import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/upload/upload_repository.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class UploadFileViewModel extends ViewStateViewModel {
  final UploadRepository _uploadRepository;

  UploadFileViewModel(this._uploadRepository);

  void upload(int projectId, MultipartFile file) async {
    emitLoading();
    try {
      await _uploadRepository.uploadFile(projectId, file);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
