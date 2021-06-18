import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel<T> {
  final BehaviorSubject<T> _data = BehaviorSubject();
  final CompositeSubscription _subscriptions = CompositeSubscription();

  void emit(T data) => _data.add(data);

  void emitFailure(dynamic error) => _data.addError(error);

  void addSubscription(StreamSubscription subscription) =>
      _subscriptions.add(subscription);

  ValueStream<T> get data => _data;

  T? get state => _data.value;

  void dispose() {
    _data.close();
    _subscriptions.dispose();
  }
}
