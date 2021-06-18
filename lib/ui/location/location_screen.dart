import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/ui/location/location_view_model.dart';
import 'package:guardspot/util/extensions/google_map_extensions.dart';
import 'package:provider/provider.dart';

/*
 * This is only to be included in the mobile apps
 * (Android & iOS)
 */
class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with AutomaticKeepAliveClientMixin {
  LocationViewModel? _viewModel;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel!.locationUpdateResult.listen(_updateCameraLocation);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        _mapController = controller;
        _mapController?.listenToThemeChanges(context.read());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _updateCameraLocation(Location location) {
    final latLng = LatLng(location.latitude, location.longitude);
    final cameraUpdate = CameraUpdate.newLatLngZoom(latLng, _MAP_CAMERA_ZOOM);

    _mapController?.moveCamera(cameraUpdate);
  }

  static const double _MAP_CAMERA_ZOOM = 15;
}
