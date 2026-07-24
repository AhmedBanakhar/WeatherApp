import 'package:climate/model/climate_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> buildJson({
  String cityName = 'London',
  String lastUpdated = '2024-01-15 14:30',
  String icon = '//cdn.weatherapi.com/weather/64x64/day/113.png',
  double avgTemp = 20.5,
  double maxTemp = 25.0,
  double minTemp = 15.0,
  String condition = 'Sunny',
}) {
  return {
    'location': {'name': cityName},
    'current': {'last_updated': lastUpdated},
    'forecast': {
      'forecastday': [
        {
          'day': {
            'avgtemp_c': avgTemp,
            'maxtemp_c': maxTemp,
            'mintemp_c': minTemp,
            'condition': {'icon': icon, 'text': condition},
          },
        },
      ],
    },
  };
}

void main() {
  group('ClimateModel', () {
    test('constructor assigns all fields', () {
      final date = DateTime(2024, 1, 15, 14, 30);
      final model = ClimateModel(
        city: 'Paris',
        date: date,
        iconUrl: '//icon.png',
        temperature: 18.0,
        maxTemperature: 22.0,
        minTemperature: 12.0,
        weatherCondition: 'Cloudy',
      );

      expect(model.city, 'Paris');
      expect(model.date, date);
      expect(model.iconUrl, '//icon.png');
      expect(model.temperature, 18.0);
      expect(model.maxTemperature, 22.0);
      expect(model.minTemperature, 12.0);
      expect(model.weatherCondition, 'Cloudy');
    });

    test('fromJson parses every field from the API payload', () {
      final model = ClimateModel.fromJson(buildJson());

      expect(model.city, 'London');
      expect(model.date, DateTime.parse('2024-01-15 14:30'));
      expect(model.iconUrl, '//cdn.weatherapi.com/weather/64x64/day/113.png');
      expect(model.temperature, 20.5);
      expect(model.maxTemperature, 25.0);
      expect(model.minTemperature, 15.0);
      expect(model.weatherCondition, 'Sunny');
    });

    test('fromJson handles a different city and condition', () {
      final model = ClimateModel.fromJson(
        buildJson(cityName: 'Tokyo', condition: 'Light rain', avgTemp: 9.0),
      );

      expect(model.city, 'Tokyo');
      expect(model.weatherCondition, 'Light rain');
      expect(model.temperature, 9.0);
    });

    test('fromJson throws when a required key is missing', () {
      final broken = buildJson()..remove('location');

      expect(() => ClimateModel.fromJson(broken), throwsA(anything));
    });
  });
}
