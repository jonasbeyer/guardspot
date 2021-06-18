import 'dart:math';

import 'package:guardspot/models/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsUtil {
  MapsUtil._();

  static startNavigation(Location loc) async {
    String url = "google.navigation:q=${loc.latitude},${loc.longitude}";
    await launch(url);
  }

  // Returns distance in meters
  static distanceBetween(Location loc1, Location loc2) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(loc2.latitude - loc1.latitude);
    var dLon = _toRadians(loc2.longitude - loc1.latitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(loc1.latitude)) *
            cos(_toRadians(loc2.latitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }
}
