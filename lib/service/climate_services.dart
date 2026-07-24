import 'dart:developer';

import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_exception.dart';
import 'package:dio/dio.dart';

class ClimateServices {
  final Dio dio;
  final String basesUrl = 'https://api.weatherapi.com/v1';
  final String apiKey = 'f5dd6593e7094c349a9155250261205';
  ClimateServices(this.dio);
  Future<ClimateModel> getClimate({required String city}) async {
    try {
      final response = await dio.get(
        '$basesUrl/forecast.json?key=$apiKey&q=$city&days=1',
      );
      return ClimateModel.fromJson(response.data);
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
