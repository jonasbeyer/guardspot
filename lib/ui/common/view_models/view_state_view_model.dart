import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:guardspot/util/exceptions/api_exception.dart';
import 'package:rxdart/rxdart.dart';

abstract class ViewStateViewModel<T> extends BaseViewModel<ViewState> {
  void emitLoading() => emit(ViewState.loading());

  void emitSuccess({dynamic data}) => emit(ViewState.success(data: data));

  void emitError(String errorKey) => emit(ViewState.error(errorKey));

  void emitForUnhandledError(dynamic error) {
    if (error is! ApiException) {
      Fimber.e("Internal exception", ex: error);
      emitError("an_error_occurred");
      return;
    }

    switch (error.apiError) {
      case ApiError.NETWORK_UNAVAILABLE:
        emitError("network_error");
        break;
      default:
        emitError("an_error_occurred");
        break;
    }
  }

  Stream<void> get onSuccess =>
      data.where((state) => state is ViewStateSuccess);

  Stream<ViewStateError> get onError =>
      data.where((state) => state is ViewStateError).cast();

  Stream<bool> get onLoading => data
      .map((state) => state is ViewStateLoading)
      .debounceTime(Duration(milliseconds: 250))
      .distinct();

  Stream<T> get viewStateResult => data
      .where((it) => it is ViewStateSuccess || it is ViewStateError)
      .map((state) => state is ViewStateSuccess
          ? state.data
          : throw (state as ViewStateError).errorKey);
}

abstract class ViewState {
  ViewState._();

  factory ViewState.initial() => ViewStateInitial();

  factory ViewState.loading() => ViewStateLoading();

  factory ViewState.success({dynamic data}) => ViewStateSuccess(data);

  factory ViewState.error(String errorKey) = ViewStateError;
}

class ViewStateInitial extends ViewState {
  ViewStateInitial() : super._();
}

class ViewStateLoading extends ViewState {
  ViewStateLoading() : super._();
}

class ViewStateSuccess extends ViewState {
  final dynamic data;

  ViewStateSuccess(this.data) : super._();
}

class ViewStateError extends ViewState {
  final String errorKey;

  ViewStateError(this.errorKey) : super._();
}
