import 'package:climate/get_climate_cubit/get_climate_cubit.dart';
import 'package:climate/get_climate_cubit/get_climate_states.dart';
import 'package:climate/widget/climate_info_body.dart';
import 'package:climate/widget/climate_status_card.dart';
import 'package:climate/widget/glass_container.dart';
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
        centerTitle: false,
        title: const Row(
          children: [
            Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 26),
            SizedBox(width: 10),
            Text(
              'Weather',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<GetClimateCubit, ClimateState>(
        builder: (context, state) {
          final weatherCondition = BlocProvider.of<GetClimateCubit>(
            context,
          ).climateModel?.weatherCondition;

          final themeColor = getThemeColor(weatherCondition, primaryColor);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _shift(themeColor, -0.22),
                  themeColor,
                  _shift(themeColor, 0.28),
                ],
                stops: const [0.0, 0.45, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Find weather for any city',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.97),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type a city name below and get today’s weather instantly.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SearchBar(
                      controller: _searchController,
                      onSubmit: _searchCity,
                    ),
                    const SizedBox(height: 36),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        ),
                      ),
                      child: _buildBody(state),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ClimateState state) {
    if (state is ClimateLoadingState) {
      return const StatusCard(
        key: ValueKey('loading'),
        title: 'Loading weather',
        subtitle: 'Fetching the latest data for your city.',
        icon: Icons.cloud_download_outlined,
      );
    }
    if (state is ClimateFaillureState) {
      return StatusCard(
        key: const ValueKey('failure'),
        title: 'Something went wrong',
        subtitle: 'Please check the city name and try again.',
        icon: Icons.error_outline,
        actionLabel: 'Try again',
        action: _searchCity,
      );
    }
    if (state is ClimateLoadedState) {
      return ClimateInfoBody(
        key: const ValueKey('loaded'),
        climateModel: state.climateModel,
      );
    }
    return const NoClimateBody(key: ValueKey('empty'));
  }
}

/// A frosted-glass search field with a rounded send button.
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      borderRadius: 22,
      opacity: 0.22,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmit(),
              cursorColor: Colors.white,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                hintText: 'Search city',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSubmit,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shifts a color's lightness by [amount] (negative = darker, positive =
/// lighter) so a single theme color yields a pleasing gradient.
Color _shift(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
      .toColor();
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
