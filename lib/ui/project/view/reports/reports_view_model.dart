import 'package:injectable/injectable.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/data/report/report_repository.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ReportsViewModel extends BaseViewModel<List<Report>> {
  final ReportRepository _reportRepository;

  ReportsViewModel(this._reportRepository);

  void loadReports(int projectId) => addSubscription(_reportRepository
      .getObservableReports(projectId)
      .listen(emit, onError: emitFailure));
}
