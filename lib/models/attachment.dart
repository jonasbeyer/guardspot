import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Attachment {
  final String filename;
  final String contentType;
  final String downloadUrl;

  Attachment({
    required this.filename,
    required this.contentType,
    required this.downloadUrl,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}