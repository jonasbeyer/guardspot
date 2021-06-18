import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/models/prediction.dart';
import 'package:guardspot/ui/project/add_edit/add_edit_project_view_model.dart';
import 'package:rxdart/rxdart.dart';

class AutocompleteDialog extends StatefulWidget {
  final AddEditProjectViewModel viewModel;
  final String? startText;
  final String hint;
  final num? offset;
  final num? radius;
  final String? language;
  final String? sessionToken;
  final List<String>? types;
  final bool? strictbounds;
  final String? region;
  final Duration? debounce;

  AutocompleteDialog({
    required this.viewModel,
    this.hint = "Search",
    this.offset,
    this.radius,
    this.language,
    this.sessionToken,
    this.types,
    this.strictbounds,
    this.region,
    this.startText,
    this.debounce = const Duration(milliseconds: 300),
  });

  @override
  State<AutocompleteDialog> createState() => _PlacesAutocompleteOverlayState();
}

class _PlacesAutocompleteOverlayState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_searching) {
      body = _buildSearching();
    } else if (_queryTextController.text.isEmpty || _predictions.isEmpty) {
      body = _buildEmpty();
    } else {
      body = _buildResults();
    }

    return Padding(
      padding: Theme.of(context).platform == TargetPlatform.iOS
          ? EdgeInsets.only(top: 8.0)
          : EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Stack(
          children: [
            Column(
              children: [
                Material(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black45
                            : null,
                        icon: Theme.of(context).platform == TargetPlatform.iOS
                            ? Icon(Icons.arrow_back_ios)
                            : Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: _buildTextField(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 48.0),
              child: body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearching() {
    return Stack(
      alignment: FractionalOffset.bottomCenter,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxHeight: 2.0),
          child: LinearProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Material(
      color: Theme.of(context).dialogBackgroundColor,
      child: _PoweredByGoogleImage(),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(2),
        bottomRight: Radius.circular(2),
      ),
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      child: Material(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
        color: Theme.of(context).dialogBackgroundColor,
        child: ListBody(
          children: _predictions
              .map((prediction) => ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(prediction.description),
                    onTap: () => Navigator.of(context).pop(prediction),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _queryTextController,
      autofocus: true,
      style: TextStyle(
        fontSize: 16.0,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black87
            : null,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black45
              : null,
        ),
      ),
    );
  }
}

abstract class PlacesAutocompleteState extends State<AutocompleteDialog> {
  late TextEditingController _queryTextController;
  late List<Prediction> _predictions;
  late bool _searching;

  Timer? _debounce;
  BehaviorSubject<String> _queryBehavior = BehaviorSubject.seeded("");

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: widget.startText);
    _queryTextController.addListener(_onQueryChange);
    _queryBehavior.stream.listen(doSearch);

    _searching = false;
    _predictions = [];
  }

  Future<Null> doSearch(String value) async {
    if (mounted && value.isNotEmpty) {
      setState(() => _searching = true);

      widget.viewModel
          .getPredictions(
            value,
            locale: widget.language,
            sessionToken: widget.sessionToken,
            country: "de",
          )
          .then((value) => onResponse(value))
          .catchError((error) => onResponseError(error));
    } else {
      onResponse([]);
    }
  }

  void _onQueryChange() {
    _debounce?.cancel();
    _debounce = Timer((widget.debounce!), () {
      if (!_queryBehavior.isClosed)
        _queryBehavior.add(_queryTextController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _queryBehavior.close();
    _queryTextController.removeListener(_onQueryChange);
  }

  void onResponseError(DioError res) {
    if (!mounted) return;

    setState(() {
      _predictions = [];
      _searching = false;
    });
  }

  void onResponse(List<Prediction> predictions) {
    if (!mounted) return;

    setState(() {
      _predictions = predictions;
      _searching = false;
    });
  }
}

class _PoweredByGoogleImage extends StatelessWidget {
  final _poweredByGoogleWhite = "images/google_white.png";
  final _poweredByGoogleBlack = "images/google_black.png";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? _poweredByGoogleWhite
                : _poweredByGoogleBlack,
            scale: 2.5,
          ),
        )
      ],
    );
  }
}
