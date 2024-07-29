extension NullableString on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}
