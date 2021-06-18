import 'package:injectable/injectable.dart';
import 'package:guardspot/data/location/autocomplete_service.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/models/place_details.dart';
import 'package:guardspot/models/prediction.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AddEditProjectViewModel extends ViewStateViewModel {
  final ProjectRepository _projectRepository;
  final AutocompleteService _autocompleteService;

  final BehaviorSubject<Project> _project = BehaviorSubject();

  AddEditProjectViewModel(this._projectRepository, this._autocompleteService);

  void setInitialProject(Project? project) =>
      _project.add(project ?? Project(latitude: 52.5, longitude: 13.3));

  void submit() async {
    emitLoading();

    try {
      await _projectRepository.saveProject(_project.value!);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }

  void update({
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
  }) {
    Project newProject = _project.value!.copyWith(
      name: name,
      description: description,
      longitude: longitude,
      latitude: latitude,
      address: address,
      postalCode: postalCode,
      city: city,
      countryCode: countryCode,
      clientName: clientName,
      clientPhone: clientPhone,
    );

    _project.add(newProject);
  }

  Future<List<Prediction>> getPredictions(
    String query, {
    String? sessionToken,
    String? locale,
    String? country,
  }) {
    return _autocompleteService.getPredictions(
      query,
      locale: locale,
      countryCode: country,
      sessionToken: sessionToken,
    );
  }

  Future<void> updateLocation(
    Prediction prediction,
    String sessionToken, {
    String locale = "de",
  }) async {
    PlaceDetails details = await _autocompleteService.getPlaceDetails(
      prediction.placeId,
      locale: locale,
      sessionToken: sessionToken,
    );

    update(
      address: details.address,
      city: details.city,
      postalCode: details.postalCode,
      countryCode: details.country,
      latitude: details.latitude,
      longitude: details.longitude,
    );
  }

  Project get project => _project.value!;

  ValueStream<Project> get observableProject => _project;

  ValueStream<Location> get location => _project.map((it) => it.location!);

  @override
  void dispose() {
    super.dispose();
    _project.close();
  }
}
