import 'package:injectable/injectable.dart';
import 'package:guardspot/data/location/location_service.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class LocationViewModel extends BaseViewModel {
  static const int _MAP_LOCATION_UPDATE_INTERVAL = 8000;
  static const int _MAP_LOCATION_UPDATE_DISPLACEMENT = 10;

  final LocationService _locationService;

  LocationViewModel(this._locationService);

  Stream<Location> get locationUpdateResult =>
      _locationService.observeCurrentLocation(
          distanceFilter: _MAP_LOCATION_UPDATE_DISPLACEMENT,
          timeInterval: _MAP_LOCATION_UPDATE_INTERVAL);
}
