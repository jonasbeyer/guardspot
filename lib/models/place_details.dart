import 'package:json_annotation/json_annotation.dart';

part 'place_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlaceDetails {
  final String address;
  final String city;
  final String country;
  final String postalCode;

  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);
}
