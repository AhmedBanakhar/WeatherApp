import 'package:climate/model/climate_model.dart';

class ClimateState {}

class NoClimateState extends ClimateState {}

class ClimateLoadingState extends ClimateState {}

class ClimateLoadedState extends ClimateState {
  final ClimateModel climateModel;

  ClimateLoadedState(this.climateModel);
}

class ClimateFaillureState extends ClimateState {}
