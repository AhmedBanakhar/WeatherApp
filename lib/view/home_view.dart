import 'package:climate/get_climate_cubit/get_climate_cubit.dart';
import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/widget/climate_info_body.dart';
import 'package:climate/widget/climate_status_card.dart';
import 'package:climate/widget/no_climate_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  void _searchCity() {
    final city = _searchController.text.trim();
    if (city.isEmpty) return;
    FocusScope.of(context).unfocus();
    BlocProvider.of<GetClimateCubit>(context).getClimate(city: city);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Weather',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<GetClimateCubit, ClimateState>(
          builder: (context, state) {
            final weatherCondition = BlocProvider.of<GetClimateCubit>(
              context,
            ).climateModel?.weatherCondition;

            final themeColor = getThemeColor(weatherCondition, primaryColor);

            return Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColor.withOpacity(0.76), // بديل shade300
                    themeColor.withOpacity(0.85), // بديل shade200
                    themeColor.withOpacity(0.95), // بديل shade100
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Find weather for any city',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type a city name below and get today’s weather instantly.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => _searchCity(),
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                  hintText: 'Search city',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: themeColor.withOpacity(0.72),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _searchCity,
                              child: Container(
                                height: 56,
                                width: 56,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: themeColor.withOpacity(0.72),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (state is ClimateLoadingState) ...[
                        StatusCard(
                          context: context,
                          title: 'Loading weather',
                          subtitle: 'Fetching the latest data for your city.',
                          icon: Icons.cloud_download_outlined,
                        ),
                      ] else if (state is ClimateFaillureState) ...[
                        StatusCard(
                          context: context,
                          title: 'Something went wrong',
                          subtitle: state.errMessage,
                          icon: Icons.error_outline,
                          actionLabel: 'Try again',
                          action: _searchCity,
                        ),
                      ] else if (state is ClimateLoadedState) ...[
                        ClimateInfoBody(climateModel: state.climateModel),
                      ] else ...[
                        NoClimateBody(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color getThemeColor(String? condition, Color defaultColor) {
  if (condition == null || condition.isEmpty) {
    return defaultColor;
  }
  switch (condition) {
    // ☀️ Sunny / Clear
    case 'Sunny':
    case 'Clear':
      return Colors.orange;

    // ⛅ Partly cloudy
    case 'Partly cloudy':
      return Colors.amber;

    // ☁️ Cloudy / Overcast
    case 'Cloudy':
    case 'Overcast':
      return Colors.blueGrey;

    // 🌫 Mist / Fog
    case 'Mist':
    case 'Fog':
    case 'Freezing fog':
      return Colors.grey;

    // 🌦 Light rain / drizzle
    case 'Patchy rain possible':
    case 'Patchy light drizzle':
    case 'Light drizzle':
    case 'Patchy light rain':
    case 'Light rain':
    case 'Light rain shower':
      return Colors.lightBlue;

    // 🌧 Heavy rain
    case 'Moderate rain at times':
    case 'Moderate rain':
    case 'Heavy rain at times':
    case 'Heavy rain':
    case 'Moderate or heavy rain shower':
    case 'Torrential rain shower':
      return Colors.indigo;

    // ❄️ Snow
    case 'Patchy snow possible':
    case 'Blowing snow':
    case 'Blizzard':
    case 'Patchy light snow':
    case 'Light snow':
    case 'Patchy moderate snow':
    case 'Moderate snow':
    case 'Patchy heavy snow':
    case 'Heavy snow':
    case 'Light snow showers':
    case 'Moderate or heavy snow showers':
      return Colors.lightBlue;

    // 🧊 Ice / Sleet
    case 'Patchy sleet possible':
    case 'Patchy freezing drizzle possible':
    case 'Freezing drizzle':
    case 'Heavy freezing drizzle':
    case 'Light freezing rain':
    case 'Moderate or heavy freezing rain':
    case 'Light sleet':
    case 'Moderate or heavy sleet':
    case 'Ice pellets':
    case 'Light sleet showers':
    case 'Moderate or heavy sleet showers':
    case 'Light showers of ice pellets':
    case 'Moderate or heavy showers of ice pellets':
      return Colors.cyan;

    // ⛈ Thunder
    case 'Thundery outbreaks possible':
    case 'Patchy light rain with thunder':
    case 'Moderate or heavy rain with thunder':
    case 'Patchy light snow with thunder':
    case 'Moderate or heavy snow with thunder':
      return Colors.deepPurple;

    // default
    default:
      return defaultColor;
  }
}
