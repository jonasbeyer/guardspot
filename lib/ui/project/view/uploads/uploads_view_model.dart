import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/upload/upload_repository.dart';
import 'package:guardspot/models/upload.dart';

@injectable
class UploadsViewModel extends BaseViewModel<List<Upload>> {
  final UploadRepository _uploadRepository;

  UploadsViewModel(this._uploadRepository);

  void setProjectId(int projectId) => addSubscription(_uploadRepository
      .getObservableUploads(projectId)
      .listen(emit, onError: emitFailure));
}
