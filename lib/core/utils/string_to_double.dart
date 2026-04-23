double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
  return 0.0;
}

/// Parses a dynamic value to a nullable double.
/// Returns null if the value is null, otherwise parses it to double.
/// Returns null on parse errors for nullable fields.
double? parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is String) {
    if (value.isEmpty) return null;
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}
