import 'package:injectable/injectable.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:dio/dio.dart';

@lazySingleton
class ScheduleService {
  final Dio dio;

  ScheduleService(this.dio);

  Future<void> addScheduleEntry(ScheduleEntry scheduleEntry) => dio.post(
        "projects/${scheduleEntry.projectId}/schedule_entries",
        data: scheduleEntry.toJson(),
        options: Options(listFormat: ListFormat.multiCompatible),
      );

  Future<void> updateScheduleEntry(ScheduleEntry scheduleEntry) => dio.put(
        "projects/${scheduleEntry.projectId}/schedule_entries/${scheduleEntry.id}",
        data: scheduleEntry.toJson(),
        options: Options(listFormat: ListFormat.multiCompatible),
      );

  Future<void> deleteScheduleEntry(int projectId, int entryId) =>
      dio.delete("projects/$projectId/schedule_entries/$entryId");

  Future<List<ScheduleEntry>> getScheduleEntries(int projectId) async {
    Response response = await dio.get('projects/$projectId/schedule_entries');
    return (response.data! as List<dynamic>)
        .map((i) => ScheduleEntry.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
