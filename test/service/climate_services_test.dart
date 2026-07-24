import 'dart:convert';
import 'dart:typed_data';

import 'package:climate/service/climate_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// A configurable [HttpClientAdapter] so [ClimateServices] can be exercised
/// without performing real network requests.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.responseBody, this.error});

  final Map<String, dynamic>? responseBody;
  final DioException Function(RequestOptions options)? error;

  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (error != null) {
      throw error!(options);
    }
    return ResponseBody.fromString(
      jsonEncode(responseBody),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> validPayload() => {
      'location': {'name': 'Cairo'},
      'current': {'last_updated': '2024-03-10 09:15'},
      'forecast': {
        'forecastday': [
          {
            'day': {
              'avgtemp_c': 27.0,
              'maxtemp_c': 31.0,
              'mintemp_c': 21.0,
              'condition': {
                'icon': '//cdn/icon.png',
                'text': 'Sunny',
              },
            },
          },
        ],
      },
    };

void main() {
  group('ClimateServices.getClimate', () {
    test('returns a parsed ClimateModel on success', () async {
      final adapter = _FakeAdapter(responseBody: validPayload());
      final dio = Dio()..httpClientAdapter = adapter;
      final service = ClimateServices(dio);

      final model = await service.getClimate(city: 'Cairo');

      expect(model.city, 'Cairo');
      expect(model.temperature, 27.0);
      expect(model.maxTemperature, 31.0);
      expect(model.minTemperature, 21.0);
      expect(model.weatherCondition, 'Sunny');
    });

    test('sends the city as a query parameter to the forecast endpoint',
        () async {
      final adapter = _FakeAdapter(responseBody: validPayload());
      final dio = Dio()..httpClientAdapter = adapter;
      final service = ClimateServices(dio);

      await service.getClimate(city: 'Cairo');

      expect(adapter.lastRequest, isNotNull);
      expect(adapter.lastRequest!.uri.toString(), contains('forecast.json'));
      expect(adapter.lastRequest!.uri.toString(), contains('q=Cairo'));
    });

    test('throws when the request fails with a DioException', () async {
      final adapter = _FakeAdapter(
        error: (options) => DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final service = ClimateServices(dio);

      expect(() => service.getClimate(city: 'Nowhere'), throwsA(anything));
    });

    test('throws an Exception when the payload cannot be parsed', () async {
      final adapter = _FakeAdapter(responseBody: {'unexpected': 'shape'});
      final dio = Dio()..httpClientAdapter = adapter;
      final service = ClimateServices(dio);

      expect(
        () => service.getClimate(city: 'Cairo'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
