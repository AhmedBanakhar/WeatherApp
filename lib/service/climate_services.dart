import 'dart:developer';

import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_exception.dart';
import 'package:dio/dio.dart';

/// Custom Exception Class
class ClimateException implements Exception {
  final String message;

  ClimateException(this.message);

  @override
  String toString() => message;
}

class ClimateServices {
  final Dio dio;
  final String basesUrl = 'https://api.weatherapi.com/v1';

  static const String apiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: 'f5dd6593e7094c349a9155250261205',
  );

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
          (data is Map &&
              data['error'] is Map &&
              data['error']['message'] is String)
          ? data['error']['message'] as String
          : 'Oops, there was an error. Please try again later.';
      throw Exception(errMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Climate data: $e');
    }
  }
}
