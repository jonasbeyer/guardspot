import 'package:injectable/injectable.dart';
import 'package:guardspot/data/report/report_service.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ReportViewModel extends BaseViewModel<Report> {
  final ReportService _reportService;

  ReportViewModel(this._reportService);

  void loadReport(int projectId, int uploadId) {
    _reportService
        .getReport(projectId, uploadId)
        .then((report) => emit(report))
        .catchError((error) => emitFailure(error));
  }
}
