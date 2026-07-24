import 'dart:developer';

import 'package:climate/model/climate_model.dart';
import 'package:dio/dio.dart';

class ClimateServices {
  final Dio dio;
  final String basesUrl = 'https://api.weatherapi.com/v1';

  // The API key is provided at build/run time via a compile-time environment
  // variable so it is never hardcoded in source control. Supply it with:
  //   flutter run --dart-define=WEATHER_API_KEY=your_key
  //   flutter build <target> --dart-define=WEATHER_API_KEY=your_key
  static const String apiKey = String.fromEnvironment('WEATHER_API_KEY');

  ClimateServices(this.dio);

  Future<ClimateModel> getClimate({required String city}) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'Missing WEATHER_API_KEY. Provide it with '
        '--dart-define=WEATHER_API_KEY=your_key',
      );
    }
    try {
      final response = await dio.get(
        '$basesUrl/forecast.json',
        queryParameters: {
          'key': apiKey,
          'q': city,
          'days': 1,
        },
      );
      ClimateModel climateModel = ClimateModel.fromJson(response.data);
      return climateModel;
    } on DioException catch (e) {
      final data = e.response?.data;
      String errMessage = 'oops there was an error, try later';
      if (data is Map && data['error'] is Map) {
        final message = data['error']['message'];
        if (message is String && message.isNotEmpty) {
          errMessage = message;
        }
      }
      throw Exception(errMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Climate data: $e');
    }
  }
}
