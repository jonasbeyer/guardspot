import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/location.dart';

@lazySingleton
class LocationService {
  Future<Location> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    return Location(position.latitude, position.longitude);
  }

  Stream<Location> observeCurrentLocation({
    int distanceFilter = 0,
    int timeInterval = 0,
  }) {
    return Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      intervalDuration: Duration(seconds: timeInterval),
      distanceFilter: distanceFilter,
    ).map((it) => Location(it.latitude, it.longitude));
  }
}
