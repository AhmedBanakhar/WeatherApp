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

  factory ClimateModel.fromJson(json) {
    return ClimateModel(
      city: json['location']['name'],
      date: DateTime.parse(json['current']['last_updated']),
      iconUrl: json['forecast']['forecastday'][0]['day']['condition']['icon'],
      temperature: json['forecast']['forecastday'][0]['day']['avgtemp_c'],
      maxTemperature: json['forecast']['forecastday'][0]['day']['maxtemp_c'],
      minTemperature: json['forecast']['forecastday'][0]['day']['mintemp_c'],
      weatherCondition:
          json['forecast']['forecastday'][0]['day']['condition']['text'],
    );
  }
}

