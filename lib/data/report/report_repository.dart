import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/report/report_service.dart';
import 'package:guardspot/data/websocket/socket_service.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/util/extensions/web_socket_extensions.dart';

@lazySingleton
class ReportRepository {
  final ReportService _reportService;
  final SocketService _socketService;

  ReportRepository(this._reportService, this._socketService);

  Future<void> createReport(
    int projectId,
    String message, {
    List<MultipartFile>? files,
  }) {
    return _reportService.createReport(projectId, message, files: files);
  }

  Future<void> updateReport(int projectId, int reportId, String message) =>
      _reportService.updateReport(projectId, reportId, message);

  Future<List<Report>> getReports(int projectId) =>
      _reportService.getReports(projectId);

  Stream<List<Report>> getObservableReports(int projectId) {
    return _socketService
        .subscribe(
          channel: "ProjectChannel",
          modelId: projectId,
          modelType: ModelType.REPORT,
        )
        .accumulate(initialSnapshot: () => getReports(projectId));
  }
}
