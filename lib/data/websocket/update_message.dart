import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/models/user.dart';

part 'update_message.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class UpdateMessage<T> {
  final T data;
  final ModelEvent event;
  final ModelType typeName;

  UpdateMessage(this.data, this.event, this.typeName);

  factory UpdateMessage.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageFromJson(json, (data) {
        ModelType type = _$enumDecode(_$ModelTypeEnumMap, json['typeName']);
        Map<String, dynamic> typedMap = data as Map<String, dynamic>;

        switch (type) {
          case ModelType.PROJECT:
            return Project.fromJson(typedMap) as T;
          case ModelType.REPORT:
            return Report.fromJson(typedMap) as T;
          case ModelType.USER:
            return User.fromJson(typedMap) as T;
          case ModelType.SCHEDULE_ENTRY:
            return ScheduleEntry.fromJson(typedMap) as T;
          case ModelType.UPLOAD:
            return Upload.fromJson(typedMap) as T;
          default:
            return {} as T;
        }
      });

  UpdateMessage<E> typedAs<E>() => UpdateMessage(data as E, event, typeName);
}

enum ModelEvent {
  @JsonValue("add")
  ADD,
  @JsonValue("update")
  UPDATE,
  @JsonValue("remove")
  REMOVE,
}

enum ModelType {
  @JsonValue("project")
  PROJECT,
  @JsonValue("report")
  REPORT,
  @JsonValue("schedule_entry")
  SCHEDULE_ENTRY,
  @JsonValue("upload")
  UPLOAD,
  @JsonValue("user")
  USER
}
