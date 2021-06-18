import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/attachment.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/user.dart';

part 'report.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Report extends Model {
  final String? message;

  @JsonKey(toJson: toNull)
  final int? projectId;

  @JsonKey(toJson: toNull)
  final User? user;

  @JsonKey(toJson: toNull)
  final List<Comment>? comments;

  @JsonKey(toJson: toNull)
  final List<Attachment>? attachments;

  @JsonKey(toJson: toNull)
  final DateTime? createdAt;

  @JsonKey(toJson: toNull)
  final DateTime? updatedAt;

  Report({
    int? id,
    this.projectId,
    this.user,
    this.message,
    this.attachments,
    this.comments,
    this.createdAt,
    this.updatedAt,
  }) : super(id);

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
