import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/model/climate_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClimateState hierarchy', () {
    test('all concrete states are subtypes of ClimateState', () {
      expect(NoClimateState(), isA<ClimateState>());
      expect(ClimateLoadingState(), isA<ClimateState>());
      expect(ClimateFaillureState(), isA<ClimateState>());
    });

    test('ClimateLoadedState carries the provided model', () {
      final model = ClimateModel(
        city: 'Berlin',
        date: DateTime(2024, 5, 1, 8, 0),
        iconUrl: '//icon.png',
        temperature: 14.0,
        maxTemperature: 18.0,
        minTemperature: 9.0,
        weatherCondition: 'Overcast',
      );

      final state = ClimateLoadedState(model);

      expect(state, isA<ClimateState>());
      expect(state.climateModel, same(model));
      expect(state.climateModel.city, 'Berlin');
    });
  });
}
