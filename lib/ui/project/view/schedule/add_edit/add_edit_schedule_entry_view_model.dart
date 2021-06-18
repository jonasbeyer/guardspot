import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/schedule/schedule_repository.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AddEditScheduleEntryViewModel extends ViewStateViewModel {
  final ScheduleRepository _scheduleRepository;
  final BehaviorSubject<ScheduleEntry> _scheduleEntry = BehaviorSubject();

  AddEditScheduleEntryViewModel(this._scheduleRepository);

  void setInitialEntry(ScheduleEntry scheduleEntry) =>
      _scheduleEntry.add(scheduleEntry);

  Future<void> submit() async {
    emitLoading();
    try {
      await _scheduleRepository.saveScheduleEntry(_scheduleEntry.value!);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }

  void update({
    String? title,
    String? description,
    DateTime? date,
    DateTime? startsAt,
    DateTime? endsAt,
    List<User>? users,
  }) =>
      _scheduleEntry.add(scheduleEntry.copyWith(
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        userIds: users?.map((user) => user.id!).toList(),
      ));

  bool updateTime({TimeOfDay? startsAt, TimeOfDay? endsAt}) {
    // if (startsAt?.isLowerOrEqualTo(scheduleEntry.endsAt!) == true) {
    //   update(startsAt: startsAt);
    //   return true;
    // }
    // if (endsAt?.isGreaterOrEqualTo(scheduleEntry.startsAt!) == true) {
    //   update(endsAt: endsAt);
    //   return true;
    // }

    return false;
  }

  ScheduleEntry get scheduleEntry => _scheduleEntry.value!;

  Stream<ScheduleEntry> get observableScheduleEntry => _scheduleEntry;

  @override
  void dispose() {
    super.dispose();
    _scheduleEntry.close();
  }
}
