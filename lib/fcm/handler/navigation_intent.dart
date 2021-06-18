import 'package:json_annotation/json_annotation.dart';

part 'navigation_intent.g.dart';

@JsonSerializable()
class NavigationIntent {
  final String route;
  final dynamic data;

  NavigationIntent(this.route, this.data);

  factory NavigationIntent.fromJson(Map<String, dynamic> json) =>
      _$NavigationIntentFromJson(json);

  Map<String, dynamic> toJson() => _$NavigationIntentToJson(this);
}
