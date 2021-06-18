import 'package:json_annotation/json_annotation.dart';

part 'recording.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Recording {
  final String type;
  final Map<String, dynamic> data;

  Recording({
    required this.type,
    required this.data,
  });

  factory Recording.fromJson(Map<String, dynamic> json) =>
      _$RecordingFromJson(json);
}
