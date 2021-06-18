import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/models/model.dart';

part 'schedule_entry.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScheduleEntry extends Model {
  final String? title;
  final String? description;
  final DateTime? date;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final List<int>? userIds;

  @JsonKey(toJson: toNull)
  final int? projectId;

  @JsonKey(toJson: toNull)
  final List<User> users;

  @JsonKey(toJson: toNull)
  final DateTime? createdAt;

  @JsonKey(toJson: toNull)
  final DateTime? updatedAt;

  ScheduleEntry({
    int? id,
    this.projectId,
    this.title,
    this.description,
    this.startsAt,
    this.date,
    this.endsAt,
    this.users = const [],
    this.userIds,
    this.createdAt,
    this.updatedAt,
  }) : super(id);

  ScheduleEntry copyWith({
    String? title,
    String? description,
    List<int>? userIds,
    DateTime? date,
    DateTime? startsAt,
    DateTime? endsAt,
  }) =>
      ScheduleEntry(
        id: id,
        projectId: projectId,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        startsAt: startsAt ?? this.startsAt,
        endsAt: endsAt ?? this.endsAt,
        userIds: userIds ?? this.userIds,
      );

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEntryToJson(this);
}
