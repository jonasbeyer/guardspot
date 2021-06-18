import 'package:injectable/injectable.dart';
import 'package:guardspot/data/schedule/schedule_repository.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ScheduleViewModel extends BaseViewModel<List<ScheduleEntry>> {
  final ScheduleRepository _scheduleRepository;

  ScheduleViewModel(this._scheduleRepository);

  void loadScheduleEntries(int projectId) => addSubscription(_scheduleRepository
      .getObservableScheduleEntries(projectId)
      .listen(emit, onError: emitFailure));
}
