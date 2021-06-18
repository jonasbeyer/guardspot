import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Location {
  final double latitude;
  final double longitude;
  final DateTime? updatedAt;

  Location(
    this.latitude,
    this.longitude, {
    this.updatedAt,
  });

  toLatLng() => LatLng(latitude, longitude);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
