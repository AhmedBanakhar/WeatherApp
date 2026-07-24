import 'dart:developer';

import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_exception.dart';
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
      throw ClimateException(
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
    // WeatherAPI reports failures as {"error": {"code": ..., "message": ...}}.
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