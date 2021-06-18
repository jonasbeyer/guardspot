String asName<T>(T value) {
  return value.toString().split(".").last.toLowerCase();
}

T? parse<T>(String str, List<T> values) {
  for (var v in values) {
    if (asName(v) == str) {
      return v;
    }
  }
  return null;
}