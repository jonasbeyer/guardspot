import 'package:injectable/injectable.dart';
import 'package:guardspot/data/schedule/schedule_service.dart';
import 'package:guardspot/data/websocket/socket_service.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/util/extensions/web_socket_extensions.dart';

@lazySingleton
class ScheduleRepository {
  final ScheduleService _scheduleService;
  final SocketService _socketService;

  ScheduleRepository(
    this._scheduleService,
    this._socketService,
  );

  Future<void> saveScheduleEntry(ScheduleEntry scheduleEntry) =>
      scheduleEntry.id != null
          ? _scheduleService.updateScheduleEntry(scheduleEntry)
          : _scheduleService.addScheduleEntry(scheduleEntry);

  Future<List<ScheduleEntry>> getScheduleEntries(int id) =>
      _scheduleService.getScheduleEntries(id);

  Stream<List<ScheduleEntry>> getObservableScheduleEntries(int projectId) {
    return _socketService
        .subscribe(
          channel: "ProjectChannel",
          modelId: projectId,
          modelType: ModelType.SCHEDULE_ENTRY,
        )
        .accumulate(initialSnapshot: () => getScheduleEntries(projectId));
  }
}
