import 'package:climate/model/climate_model.dart';

abstract class ClimateState {}

class NoClimateState extends ClimateState {}

class ClimateLoadingState extends ClimateState {}

class ClimateLoadedState extends ClimateState {
  final ClimateModel climateModel;

  ClimateLoadedState(this.climateModel);
}

class ClimateFailureState extends ClimateState {
  final String message;

  ClimateFailureState(this.message);
}
