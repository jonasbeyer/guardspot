import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/recording.dart';
import 'package:guardspot/models/url_response.dart';

@lazySingleton
class RecordingService {
  final Dio dio;

  RecordingService(this.dio);

  Future<UrlResponse> publish({
    int? uploadId,
    int? reportId,
  }) async {
    Map<String, dynamic> params = {
      "upload_id": uploadId,
      "report_id": reportId,
    }..removeWhere((k, v) => v == null);

    Response response = await dio.post("public_urls", data: params);
    return UrlResponse.fromJson(response.data);
  }

  Future<void> unpublish({
    int? uploadId,
    int? reportId,
  }) {
    final params = {
      "upload_id": uploadId,
      "report_id": reportId,
    }..removeWhere((k, v) => v == null);

    return dio.delete("public_urls", data: params);
  }

  Future<Recording> getRecordingBySecret(String secret) async {
    Response response = await dio.get("public_urls/$secret");
    return Recording.fromJson(response.data!);
  }
}
