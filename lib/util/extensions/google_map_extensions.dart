import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardspot/ui/common/view_models/theme_view_model.dart';

extension GoogleMapControllerThemeExtensions on GoogleMapController {
  setTheme(ThemeMode mode) async {
    String darkThemePath = "assets/map/map_style_night.json";

    String? styleAsset = mode == ThemeMode.dark ? darkThemePath : null;
    String? styleOptions =
        styleAsset != null ? await rootBundle.loadString(styleAsset) : null;

    setMapStyle(styleOptions);
  }

  listenToThemeChanges(ThemeViewModel viewModel) {
    setTheme(viewModel.currentThemeMode);
    viewModel.observableThemeMode.listen(setTheme);
  }
}
