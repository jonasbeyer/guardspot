import 'package:injectable/injectable.dart';
import 'package:guardspot/data/recording/recording_service.dart';
import 'package:guardspot/models/recording.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class PublicSharingViewModel extends BaseViewModel<Recording> {
  final RecordingService _recordingService;

  PublicSharingViewModel(this._recordingService);

  Future<void> loadRessource(String secret) async {
    try {
      Recording upload = await _recordingService.getRecordingBySecret(secret);
      emit(upload);
    } catch (e) {
      emitFailure("an_error_occurred");
    }
  }
}
