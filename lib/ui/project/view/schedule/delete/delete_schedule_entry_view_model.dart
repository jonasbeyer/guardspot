import 'package:injectable/injectable.dart';
import 'package:guardspot/data/schedule/schedule_service.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class DeleteScheduleEntryViewModel extends ViewStateViewModel {
  final ScheduleService _scheduleService;

  DeleteScheduleEntryViewModel(this._scheduleService);

  Future<void> delete(ScheduleEntry scheduleEntry) async {
    emitLoading();

    try {
      await _scheduleService.deleteScheduleEntry(
        scheduleEntry.projectId!,
        scheduleEntry.id!,
      );
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
