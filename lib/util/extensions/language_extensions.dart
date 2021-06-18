import 'package:flutter/material.dart';

extension ListExtensions<T> on List<T> {
  List<T> sortedWith(int compare(T a, T b)) {
    sort(compare);
    return this;
  }

  List<T> plus(T element) {
    add(element);
    return this;
  }

  Iterable<E> mapIndexed<E, T>(E Function(int index, T item) transform) sync* {
    var index = 0;
    for (final item in this) {
      yield transform(index, item as T);
      index++;
    }
  }
}

extension DateTimeExtensions on DateTime {
  DateTime copyWithDate(DateTime other) =>
      DateTime(other.year, other.month, other.day, hour, minute);

  DateTime copyWithTime(TimeOfDay other) =>
      DateTime(year, month, day, other.hour, other.minute);

  bool isGreaterOrEqualTo(DateTime other) =>
      this.isAfter(other) || this.isAtSameMomentAs(other);

  bool isLowerOrEqualTo(DateTime other) =>
      this.isBefore(other) || this.isAtSameMomentAs(other);
}

T? tryCast<T>(x) => x is T ? x : null;
