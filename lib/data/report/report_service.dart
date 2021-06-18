import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/report.dart';

@lazySingleton
class ReportService {
  final Dio dio;

  ReportService(this.dio);

  Future<void> createReport(
    int projectId,
    String message, {
    List<MultipartFile>? files,
  }) async {
    FormData formData = FormData.fromMap({
      "message": message,
      "images": files,
    }, ListFormat.multiCompatible);

    await dio.post("projects/$projectId/reports", data: formData);
  }

  Future<void> updateReport(
    int projectId,
    int reportId,
    String message,
  ) async {
    await dio.put("projects/$projectId/reports/$reportId",
        data: {"message": message});
  }

  Future<void> deleteReport(int projectId, int reportId) =>
      dio.delete("projects/$projectId/reports/$reportId");

  Future<Report> getReport(int projectId, int reportId) async {
    Response response = await dio.get("projects/$projectId/reports/$reportId");
    return Report.fromJson(response.data);
  }

  Future<List<Report>> getReports(int projectId) async {
    Response response = await dio.get("projects/$projectId/reports");
    return (response.data! as List<dynamic>)
        .map((i) => Report.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
