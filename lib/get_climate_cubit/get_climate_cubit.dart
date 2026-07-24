import 'dart:developer';

import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_exception.dart';
import 'package:climate/service/climate_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetClimateCubit extends Cubit<ClimateState> {
  GetClimateCubit({ClimateServices? climateServices})
      : _climateServices = climateServices ?? ClimateServices(Dio()),
        super(NoClimateState());

  final ClimateServices _climateServices;

  ClimateModel? climateModel;

  Future<void> getClimate({required String city}) async {
    try {
      emit(ClimateLoadingState());
      climateModel = await _climateServices.getClimate(city: city);
      emit(ClimateLoadedState(climateModel!));
    } on ClimateException catch (e) {
      emit(ClimateFailureState(e.message));
    } catch (e, stackTrace) {
      log(
        'Unexpected error while loading climate for "$city"',
        name: 'GetClimateCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(ClimateFailureState('Something went wrong. Please try again.'));
    }
  }
}