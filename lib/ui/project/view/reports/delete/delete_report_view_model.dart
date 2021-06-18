import 'package:injectable/injectable.dart';
import 'package:guardspot/data/report/report_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class DeleteReportViewModel extends ViewStateViewModel {
  final ReportService _reportService;

  DeleteReportViewModel(this._reportService);

  Future<void> delete(int projectId, int reportId) async {
    emitLoading();

    try {
      await _reportService.deleteReport(projectId, reportId);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
