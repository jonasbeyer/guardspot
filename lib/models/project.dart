import 'package:json_annotation/json_annotation.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';
import 'package:guardspot/util/maps_util.dart';

part 'project.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Project extends Model {
  final String? name;
  final String? description;

  final double? longitude;
  final double? latitude;
  final String? address;
  final String? postalCode;
  final String? city;
  final String? countryCode;

  final String? clientName;
  final String? clientPhone;

  final bool? archived;

  @JsonKey(toJson: toNull)
  final bool? subscribed;

  @JsonKey(toJson: toNull)
  final List<User> users;

  @JsonKey(toJson: toNull)
  final DateTime? createdAt;

  @JsonKey(toJson: toNull)
  final DateTime? updatedAt;

  Project({
    int? id,
    this.name,
    this.description,
    this.longitude,
    this.latitude,
    this.address,
    this.postalCode,
    this.city,
    this.countryCode,
    this.clientName,
    this.clientPhone,
    this.archived = false,
    this.subscribed = true,
    this.users = const [],
    this.createdAt,
    this.updatedAt,
  }) : super(id);

  Project copyWith({
    String? name,
    String? description,
    double? longitude,
    double? latitude,
    String? address,
    String? postalCode,
    String? city,
    String? countryCode,
    String? clientName,
    String? clientPhone,
    List<User>? users,
    bool? archived,
    bool? subscribed,
  }) =>
      Project(
        id: this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        postalCode: postalCode ?? this.postalCode,
        city: city ?? this.city,
        countryCode: countryCode ?? this.countryCode,
        clientName: clientName ?? this.clientName,
        clientPhone: clientPhone ?? this.clientPhone,
        users: users ?? this.users,
        archived: archived ?? this.archived,
        subscribed: subscribed ?? this.subscribed,
        createdAt: this.createdAt,
        updatedAt: DateTime.now(),
      );

  Project withUser(User user) => copyWith(users: users.plus(user));

  Project withoutUser(User user) =>
      copyWith(users: users.where((it) => it.id != user.id).toList());

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  int get nearbyUsersCount => getNearbyUsers().length;

  String get place => "$postalCode $city";

  Location? get location => latitude != null && longitude != null
      ? Location(latitude!, longitude!)
      : null;

  List<User> getNearbyUsers({int meters = 20}) {
    if (location == null) return [];
    return users
        .where((user) =>
            user.location != null &&
            MapsUtil.distanceBetween(user.location!, this.location!) <= meters)
        .toList();
  }
}

enum ProjectsFilter { ARCHIVED, INACCESSIBLE }