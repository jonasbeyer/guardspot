import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/models/model.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends Model {
  @JsonKey(toJson: null)
  final int? id;
  final String? name;
  final String? email;
  final String? token;
  final int? organizationId;
  final UserRole? role;
  final Location? location;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.organizationId,
    this.role,
    this.location,
  }) : super(id);

  String get initials =>
      name!.split(" ").fold("", (value, element) => value + element.trim()[0]);

  bool hasRole(UserRole role) => this.role == role;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum UserRole {
  @JsonValue("normal")
  NORMAL,
  @JsonValue("dispatcher")
  DISPATCHER,
  @JsonValue("admin")
  ADMIN,
}
