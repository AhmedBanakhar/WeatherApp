/// Formatting helpers for temperature values shared across weather widgets.
extension TemperatureFormat on num {
  /// Rounds the value and appends the Celsius unit, e.g. `21°C`.
  String get celsiusLabel => '${round()}\u00B0C';
}
