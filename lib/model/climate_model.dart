class ClimateModel {
  final String city;
  final DateTime date;
  final String iconUrl;
  final double temperature;
  final double maxTemperature;
  final double minTemperature;
  final String weatherCondition;

  ClimateModel({
    required this.city,
    required this.date,
    required this.iconUrl,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
  });

  factory ClimateModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final day =
        json['forecast']['forecastday'][0]['day'] as Map<String, dynamic>;

    return ClimateModel(
      city: json['location']['name'] as String,
      date: DateTime.parse(current['last_updated'] as String),
      iconUrl: current['condition']['icon'] as String,
      temperature: (current['temp_c'] as num).toDouble(),
      maxTemperature: (day['maxtemp_c'] as num).toDouble(),
      minTemperature: (day['mintemp_c'] as num).toDouble(),
      weatherCondition: current['condition']['text'] as String,
    );
  }
}
