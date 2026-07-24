import 'package:climate/get_climate_cubit/get_climate_cubit.dart';
import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeClimateServices extends ClimateServices {
  _FakeClimateServices({this.result, this.error}) : super(Dio());

  final ClimateModel? result;
  final Object? error;

  @override
  Future<ClimateModel> getClimate({required String city}) async {
    if (error != null) {
      throw error!;
    }
    return result!;
  }
}

ClimateModel sampleModel() => ClimateModel(
      city: 'Rome',
      date: DateTime(2024, 6, 1, 10, 0),
      iconUrl: '//icon.png',
      temperature: 24.0,
      maxTemperature: 28.0,
      minTemperature: 19.0,
      weatherCondition: 'Sunny',
    );

void main() {
  group('GetClimateCubit', () {
    test('starts in NoClimateState', () {
      final cubit = GetClimateCubit();
      expect(cubit.state, isA<NoClimateState>());
      cubit.close();
    });

    test('emits [Loading, Loaded] and stores the model on success', () async {
      final model = sampleModel();
      final cubit = GetClimateCubit(
        climateServices: _FakeClimateServices(result: model),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([isA<ClimateLoadingState>(), isA<ClimateLoadedState>()]),
      );

      await cubit.getClimate(city: 'Rome');
      await expectation;

      expect(cubit.climateModel, same(model));
      expect((cubit.state as ClimateLoadedState).climateModel, same(model));

      await cubit.close();
    });

    test('emits [Loading, Failure] when the service throws', () async {
      final cubit = GetClimateCubit(
        climateServices: _FakeClimateServices(error: Exception('boom')),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([isA<ClimateLoadingState>(), isA<ClimateFaillureState>()]),
      );

      await cubit.getClimate(city: 'Nowhere');
      await expectation;

      expect(cubit.state, isA<ClimateFaillureState>());

      await cubit.close();
    });
  });
}
