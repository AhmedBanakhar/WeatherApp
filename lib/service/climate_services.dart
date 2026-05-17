import 'dart:developer';

import 'package:climate/model/climate_model.dart';
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
      ClimateModel climateModel = ClimateModel.fromJson(response.data);
      return climateModel;
    } on DioException catch (e) {
      final String errMessage =
          e.response?.data[''][''] ?? 'oops there was an error,try later';
      throw Expando(errMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Climate data: $e');
    }
  }
}
