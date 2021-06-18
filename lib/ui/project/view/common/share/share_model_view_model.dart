import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/recording/recording_service.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/models/url_response.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ShareModelViewModel extends BaseViewModel<String> {
  final RecordingService _recordingService;

  ShareModelViewModel(this._recordingService);

  Future<void> fetchUrl(Model model) async {
    Future<UrlResponse> request;
    if (model is Upload) {
      request = _recordingService.publish(uploadId: model.id!);
    } else if (model is Report) {
      request = _recordingService.publish(reportId: model.id!);
    } else {
      return;
    }

    try {
      UrlResponse response = await request;
      emit(response.url);
    } catch (e) {
      emitFailure(e);
    }
  }

  Future<void> unpublish(Model model) {
    if (model is Upload) {
      return _recordingService.unpublish(uploadId: model.id!);
    } else if (model is Report) {
      return _recordingService.unpublish(reportId: model.id!);
    } else {
      return Future.error("Invalid model type");
    }
  }
}
