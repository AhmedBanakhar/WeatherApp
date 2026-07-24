import 'dart:developer';

import 'package:climate/model/climate_model.dart';
import 'package:dio/dio.dart';

class ClimateServices {
  final Dio dio;
  final String basesUrl = 'https://api.weatherapi.com/v1';

  /// The WeatherAPI key is read from the environment so it is never committed
  /// to source control. Pass it at build/run time, e.g.:
  ///   flutter run --dart-define=WEATHER_API_KEY=your_key_here
  static const String apiKey = String.fromEnvironment('WEATHER_API_KEY');

  ClimateServices(this.dio);

  Future<ClimateModel> getClimate({required String city}) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'Missing WeatherAPI key. Run with '
        '--dart-define=WEATHER_API_KEY=your_key_here',
      );
    }
    try {
      final response = await dio.get(
        '$basesUrl/forecast.json',
        queryParameters: {'key': apiKey, 'q': city, 'days': 1},
      );
      return ClimateModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final String errMessage =
          (data is Map && data['error'] is Map && data['error']['message'] is String)
          ? data['error']['message'] as String
          : 'Oops, there was an error. Please try again later.';
      throw Exception(errMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Climate data: $e');
    }
  }
}
