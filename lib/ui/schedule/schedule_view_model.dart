import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ScheduleViewModel extends BaseViewModel<List<ScheduleEntry>> {
  final UserService _userService;

  ScheduleViewModel(this._userService);

  Future<void> fetchSchedule() async {
    try {
      List<ScheduleEntry> result = await _userService.getMySchedule();
      emit(result);
    } catch (e) {
      emitFailure("an_error_occurred");
    }
  }
}
