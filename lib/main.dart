import 'package:climate/get_climate_cubit/get_climate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetClimateCubit(),
      child: Builder(
        builder: (context) => BlocBuilder<GetClimateCubit, ClimateState>(
          builder: (context, state) {
            return MaterialApp(
              // theme: ThemeData(
              //   primarySwatch: getThemeColor(
              //     BlocProvider.of<GetClimateCubit>(
              //           context,
              //         ).climateModel?.weatherCondition ??
              //         '',
              //   ),
              // ),

              debugShowCheckedModeBanner: false,
              home: HomeView(),
            );
          },
        ),
      ),
    );
  }
}

