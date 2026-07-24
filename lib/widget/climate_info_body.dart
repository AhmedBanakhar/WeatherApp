import 'dart:math';

import 'package:climate/model/climate_model.dart';
import 'package:climate/utils/temperature_format.dart';
import 'package:climate/widget/app_card.dart';
import 'package:climate/widget/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClimateInfoBody extends StatelessWidget {
  const ClimateInfoBody({super.key, required this.climateModel});
  final ClimateModel climateModel;

  @override
  Widget build(BuildContext context) {
    final int hour12 = climateModel.date.hour % 12 == 0
        ? 12
        : climateModel.date.hour % 12;
    final String period = climateModel.date.hour >= 12 ? 'PM' : 'AM';
    final time =
        '${hour12.toString().padLeft(2, '0')}:${climateModel.date.minute.toString().padLeft(2, '0')} $period';

    final themeColor = _themeColor(climateModel.weatherCondition);
    final labelColor = Colors.blueGrey.shade600;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: scale.clamp(0.0, 1.0), child: child),
        );
      },
      child: AppCard(
        bottomMargin: 26,
        elevation: 16,
        borderRadius: 28,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        climateModel.city,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Updated at $time',
                        style: TextStyle(
                          fontSize: 13,
                          color: labelColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Image.network(
                      'https:${climateModel.iconUrl}',
                      width: 64,
                      height: 64,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.wb_cloudy_rounded,
                        size: 54,
                        color: Colors.blueGrey.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🟢 تم إصلاح التجميعة هنا (Row يحتوي على العمود والمجسم)
            RoundedContainer(
              color: themeColor.withOpacity(0.12),
              borderRadius: 26,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          climateModel.temperature.celsiusLabel,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey.shade900,
                            letterSpacing: -1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          climateModel.weatherCondition,
                          style: TextStyle(
                            fontSize: 14,
                            color: labelColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _WeatherCharacter(
                    condition: climateModel.weatherCondition,
                    temperature: climateModel.temperature,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    'High',
                    climateModel.maxTemperature.celsiusLabel,
                    Colors.red.shade500,
                    Icons.arrow_upward_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatChip(
                    'Low',
                    climateModel.minTemperature.celsiusLabel,
                    Colors.blue.shade600,
                    Icons.arrow_downward_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildStatChip(
              'Last updated',
              time,
              Colors.grey.shade700,
              Icons.access_time_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Color _themeColor(String condition) {
    final value = condition.toLowerCase();

    // 1. ⛈️ العواصف الرعدية (يجب فحصها أولاً لأنها قد تحتوي على كلمات rain أو snow)
    if (value.contains('thunder')) {
      return const Color(0xFF4A40A8); // Deep Purple
    }

    // 2. 🧊 الصقيع والأمطار المتجمدة والبرد (Sleet / Ice / Freezing)
    if (value.contains('sleet') ||
        value.contains('ice') ||
        value.contains('freezing')) {
      return const Color(0xFF00ACC1); // Cyan
    }

    // 3. ❄️ الثلوج (Snow / Blizzard)
    if (value.contains('snow') || value.contains('blizzard')) {
      return const Color(0xFF5DA7C9); // Ice Blue
    }

    // 4. 🌧️ الأمطار الغزيرة أو المتوسطة (Heavy / Moderate rain / Torrential)
    if (value.contains('heavy') ||
        value.contains('torrential') ||
        value.contains('moderate rain')) {
      return const Color(0xFF1A237E); // Dark Indigo
    }

    // 5. 🌦️ الأمطار الخفيفة أو الرذاذ (Light rain / Drizzle / Patchy rain)
    if (value.contains('rain') || value.contains('drizzle')) {
      return const Color(0xFF2B5E87); // Soft Rain Blue
    }

    // 6. 🌫️ الضباب والغبار (Mist / Fog)
    if (value.contains('fog') || value.contains('mist')) {
      return const Color(0xFF78909C); // Cool Grey
    }

    // 7. ⛅ الغيوم الجزئية (Partly cloudy)
    if (value.contains('partly cloudy')) {
      return const Color(0xFFFFB300); // Amber / Soft Gold
    }

    // 8. ☁️ الغيوم الكاملة أو التغيم (Cloudy / Overcast)
    if (value.contains('cloud') || value.contains('overcast')) {
      return const Color(0xFF546E7A); // Blue Grey
    }

    // 9. ☀️ المشمش والشديد الصفاء (Sunny / Clear) أو Default
    return const Color(0xFFF5A623); // Bright Sun Amber
  }

  Widget _buildStatChip(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return RoundedContainer(
      color: Colors.grey.shade100.withOpacity(0.55),
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherCharacter extends StatefulWidget {
  const _WeatherCharacter({this.condition, required this.temperature});

  final String? condition;
  final double temperature;

  @override
  State<_WeatherCharacter> createState() => _WeatherCharacterState();
}

class _WeatherCharacterState extends State<_WeatherCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  String get _assetLabel {
    if (widget.condition == null) return 'sunny';
    final value = widget.condition!.toLowerCase();
    if (value.contains('rain') || value.contains('drizzle')) return 'rain';
    if (value.contains('snow') ||
        value.contains('sleet') ||
        value.contains('ice')) {
      return 'snow';
    }
    if (value.contains('thunder')) return 'thunder';
    if (value.contains('cloud') ||
        value.contains('fog') ||
        value.contains('mist')) {
      return 'cloud';
    }
    return 'sunny';
  }

  String get _assetPath {
    switch (_assetLabel) {
      case 'rain':
        return 'images/rainy_character.svg';
      case 'snow':
        return 'images/snowy_character.svg';
      case 'thunder':
        return 'images/thunder_character.svg';
      case 'cloud':
        return 'images/cloudy_character.svg';
      default:
        return 'images/sunny_character.svg';
    }
  }

  Color get _characterColor {
    switch (_assetLabel) {
      case 'rain':
        return Colors.blue.shade300;
      case 'snow':
        return Colors.cyan.shade200;
      case 'thunder':
        return Colors.deepPurple.shade300;
      case 'cloud':
        return Colors.blueGrey.shade200;
      default:
        return Colors.orange.shade300;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetY = sin(_controller.value * 2 * pi) * 6;
        return Transform.translate(offset: Offset(0, offsetY), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.75),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_assetLabel == 'rain') ...[
              Icon(
                Icons.umbrella_rounded,
                size: 24,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 8),
            ],
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  _assetPath,
                  width: 76,
                  height: 76,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => Icon(
                    Icons.cloud,
                    size: 52,
                    color: Colors.blueGrey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.temperature.round()}°',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _assetLabel == 'sunny'
                      ? Icons.wb_sunny
                      : _assetLabel == 'rain'
                      ? Icons.umbrella_rounded
                      : _assetLabel == 'snow'
                      ? Icons.ac_unit
                      : Icons.cloud,
                  size: 18,
                  color: _characterColor.withOpacity(0.85),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
