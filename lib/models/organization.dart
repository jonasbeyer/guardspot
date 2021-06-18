import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/user.dart';

part 'organization.g.dart';

@JsonSerializable(createToJson: false)
class Organization {
  final int id;
  final String name;
  final List<User>? users;

  Organization({
    required this.id,
    required this.name,
    this.users,
  });

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
