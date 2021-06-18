import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/models/model.dart';

part 'upload.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Upload extends Model {
  final String? filename;
  final String? contentType;
  final String? previewUrl;
  final String? downloadUrl;
  final int? byteSize;

  final int? projectId;
  final List<Comment>? comments;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Upload({
    int? id,
    this.filename,
    this.contentType,
    this.previewUrl,
    this.downloadUrl,
    this.byteSize,
    this.projectId,
    this.createdAt,
    this.updatedAt,
    this.comments,
  }) : super(id);

  factory Upload.fromJson(Map<String, dynamic> json) => _$UploadFromJson(json);
}
