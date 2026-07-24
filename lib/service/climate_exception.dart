/// Exception carrying a user-facing message about a failed climate request.
class ClimateException implements Exception {
  final String message;

  ClimateException(this.message);

  @override
  String toString() => message;
}
