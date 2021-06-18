import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/user.dart';

part 'comment.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Comment extends Model {
  final String? content;

  @JsonKey(toJson: toNull)
  final User? creator;

  @JsonKey(toJson: toNull)
  final DateTime? createdAt;

  @JsonKey(toJson: toNull)
  final DateTime? updatedAt;

  Comment({
    int? id,
    this.content,
    this.creator,
    this.createdAt,
    this.updatedAt,
  }) : super(id);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
