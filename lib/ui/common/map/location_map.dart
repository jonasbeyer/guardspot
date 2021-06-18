import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardspot/data/preferences/preference_storage.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/map/marker_generator.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/util/extensions/google_map_extensions.dart';
import 'package:provider/provider.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';
import "package:os_detect/os_detect.dart" as Platform;

class LocationMap extends StatefulWidget {
  final LatLng location;
  final List<User> users;
  final double zoom;
  final bool interactive;
  final MapType mapType;

  LocationMap(
    Location location, {
    this.zoom = 17.0,
    this.mapType = MapType.normal,
    this.interactive = false,
    this.users = const [],
  }) : this.location = location.toLatLng();

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late GoogleMapController _mapController;
  List<Marker> _userMarkers = [];

  @override
  void initState() {
    super.initState();
    _generateUserMarkers();
  }

  @override
  void didUpdateWidget(LocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location) {
      _mapController.moveCamera(CameraUpdate.newLatLng(widget.location));
    } else if (widget.users != oldWidget.users) {
      _generateUserMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypedValueStreamBuilder(
      stream: locator<PreferenceStorage>().mapsSatelliteMode.subject,
      builder: (bool satelliteMode) {
        return GoogleMap(
          liteModeEnabled: !widget.interactive && Platform.isAndroid,
          zoomGesturesEnabled: widget.interactive,
          scrollGesturesEnabled: widget.interactive,
          rotateGesturesEnabled: widget.interactive,
          zoomControlsEnabled: false,
          mapType: satelliteMode ? MapType.satellite : MapType.normal,
          initialCameraPosition: CameraPosition(
            target: widget.location,
            zoom: widget.zoom,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _mapController.listenToThemeChanges(context.read());
          },
          markers: {
            Marker(
              markerId: MarkerId(widget.location.toString()),
              position: widget.location,
            ),
            ..._userMarkers,
          },
          gestureRecognizers: Set()
            ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
        );
      },
    );
  }

  Future<void> _generateUserMarkers() async {
    List<UserAvatar> avatars = widget.users
        .where((user) => user.location != null)
        .map((user) => UserAvatar(user, style: UserAvatarStyle.micro()))
        .toList();

    if (avatars.isNotEmpty) {
      List<Uint8List> b = await MarkerGenerator(avatars).generate(context);
      List<Marker> markers = b.mapIndexed((int i, Uint8List bitmap) {
        User user = widget.users[i];
        return Marker(
          markerId: MarkerId(user.id.toString()),
          position: user.location!.toLatLng(),
          icon: BitmapDescriptor.fromBytes(bitmap),
          infoWindow: InfoWindow(title: user.name),
        );
      }).toList();

      setState(() => _userMarkers = markers);
    }
  }
}
