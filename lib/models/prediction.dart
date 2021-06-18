import 'package:json_annotation/json_annotation.dart';

part 'prediction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Prediction {
  final String placeId;
  final String description;

  Prediction({
    required this.placeId,
    required this.description,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);
}
