import 'package:json_annotation/json_annotation.dart';

abstract class Model {
  @JsonKey(toJson: toNull, includeIfNull: false)
  final int? id;

  Model(this.id);
}

toNull(_) => null;