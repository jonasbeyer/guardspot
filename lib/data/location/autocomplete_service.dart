import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/place_details.dart';
import 'package:guardspot/models/prediction.dart';

@lazySingleton
class AutocompleteService {
  final Dio dio;

  AutocompleteService(this.dio);

  Future<List<Prediction>> getPredictions(
    String query, {
    String? sessionToken,
    String? locale,
    String? countryCode,
  }) async {
    final result = await dio.get('autocomplete/predictions', queryParameters: {
      'query': query,
      'session_token': sessionToken,
      'locale': locale,
      'country_code': countryCode
    });
    return (result.data as List<dynamic>)
        .map((i) => Prediction.fromJson(i as Map<String, dynamic>))
        .toList();
  }

  Future<PlaceDetails> getPlaceDetails(
    String placeId, {
    String? locale,
    String? sessionToken,
  }) async {
    final result = await dio.get('autocomplete/details', queryParameters: {
      'place_id': placeId,
      'locale': locale,
      'session_token': sessionToken
    });
    return PlaceDetails.fromJson(result.data);
  }
}
