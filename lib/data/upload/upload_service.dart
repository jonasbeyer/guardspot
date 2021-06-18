import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:guardspot/models/upload.dart';

@lazySingleton
class UploadService {
  final Dio dio;

  UploadService(this.dio);

  Future<Upload> uploadFile(
    int projectId,
    MultipartFile file,
  ) async {
    FormData data = FormData()..files.add(MapEntry("file", file));
    Response response =
        await dio.post("projects/$projectId/uploads", data: data,);

    return Upload.fromJson(response.data);
  }

  Future<Upload> getUpload(int projectId, int uploadId) async {
    Response response = await dio.get("projects/$projectId/uploads/$uploadId");
    return Upload.fromJson(response.data);
  }

  Future<List<Upload>> getUploads(int projectId) async {
    Response result = await dio.get("projects/$projectId/uploads");
    return (result.data! as List<dynamic>)
        .map((data) => Upload.fromJson(data))
        .toList();
  }

  Future<void> deleteUpload(int projectId, int uploadId) async =>
      dio.delete("projects/$projectId/uploads/$uploadId");
}
