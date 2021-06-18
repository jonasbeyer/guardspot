import 'package:json_annotation/json_annotation.dart';

part 'url_response.g.dart';

@JsonSerializable(createToJson: false)
class UrlResponse {
  final String url;

  UrlResponse(this.url);

  factory UrlResponse.fromJson(Map<String, dynamic> json) =>
      _$UrlResponseFromJson(json);
}
