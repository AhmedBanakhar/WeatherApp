import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/model/climate_model.dart';
import 'package:climate/service/climate_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetClimateCubit extends Cubit<ClimateState> {
  GetClimateCubit() : super(NoClimateState());

  ClimateModel? climateModel;

  getClimate({required String city}) async {
    try {
      emit(ClimateLoadingState());
      climateModel = await ClimateServices(Dio()).getClimate(city: city);
      emit(ClimateLoadedState(climateModel!));
    } catch (e) {
      emit(ClimateFaillureState());
    }
  }
}
