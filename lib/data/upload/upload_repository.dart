import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/upload/upload_service.dart';
import 'package:guardspot/data/websocket/socket_service.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/util/extensions/web_socket_extensions.dart';

@lazySingleton
class UploadRepository {
  final UploadService _uploadService;
  final SocketService _socketService;

  UploadRepository(
    this._uploadService,
    this._socketService,
  );

  Future<void> uploadFile(int projectId, MultipartFile file) =>
      _uploadService.uploadFile(projectId, file);

  Future<Upload> getUpload(int projectId, int uploadId) =>
      _uploadService.getUpload(projectId, uploadId);

  Future<List<Upload>> getUploads(int projectId) =>
      _uploadService.getUploads(projectId);

  Future<void> deleteUpload(int projectId, int uploadId) =>
      _uploadService.deleteUpload(projectId, uploadId);

  Stream<List<Upload>> getObservableUploads(int projectId) {
    return _socketService
        .subscribe(
          channel: "ProjectChannel",
          modelId: projectId,
          modelType: ModelType.UPLOAD,
        )
        .accumulate(initialSnapshot: () => getUploads(projectId));
  }
}
