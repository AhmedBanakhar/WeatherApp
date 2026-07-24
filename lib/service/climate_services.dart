import 'dart:developer';

import 'package:climate/model/climate_model.dart';
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
      throw ClimateException(
        'Missing WeatherAPI key. Please provide a valid key.',
      );
    }
    try {
      final response = await dio.get(
        '$basesUrl/forecast.json',
        queryParameters: {'key': apiKey, 'q': city, 'days': 1},
      );
      return ClimateModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      log(
        'Request for "$city" failed',
        name: 'ClimateServices',
        error: e,
        stackTrace: stackTrace,
      );
      throw ClimateException(_messageFromDioError(e));
    } catch (e, stackTrace) {
      log(
        'Failed to parse climate data for "$city"',
        name: 'ClimateServices',
        error: e,
        stackTrace: stackTrace,
      );
      throw ClimateException(
        'Failed to load weather data. Please try again later.',
      );
    }
  }

  String _messageFromDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map &&
        data['error'] is Map &&
        data['error']['message'] is String) {
      return data['error']['message'] as String;
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Network error. Please check your connection and try again.';
    }
    return 'Oops, there was an error. Please try again later.';
  }
}
