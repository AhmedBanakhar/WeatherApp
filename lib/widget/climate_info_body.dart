import 'package:climate/model/climate_model.dart';
import 'package:climate/utils/temperature_format.dart';
import 'package:climate/widget/app_card.dart';
import 'package:climate/widget/rounded_container.dart';
import 'package:flutter/material.dart';

class ClimateInfoBody extends StatelessWidget {
  const ClimateInfoBody({super.key, required this.climateModel});
  final ClimateModel climateModel;

  @override
  Widget build(BuildContext context) {
    // حساب الساعة بنظام 12 ساعة وتحديد الفترة (AM / PM)
    final int hour12 = climateModel.date.hour % 12 == 0
        ? 12
        : climateModel.date.hour % 12;
    final String period = climateModel.date.hour >= 12 ? 'PM' : 'AM';

    // دمج الساعة والدقائق والفترة في متغير واحد
    final time =
        '${hour12.toString().padLeft(2, '0')}:${climateModel.date.minute.toString().padLeft(2, '0')} $period';

    return AppCard(
      elevation: 14,
      borderRadius: 28,
      color: Colors.white.withOpacity(0.96),
      bottomMargin: 24,
      padding: const EdgeInsets.all(24.0),
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
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Updated at $time',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedContainer(
                      color: Colors.blueGrey.shade50,
                      borderRadius: 18,
                      child: Text(
                        climateModel.weatherCondition,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Image.network(
                'https:${climateModel.iconUrl}',
                width: 96,
                height: 96,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.wb_cloudy_rounded,
                  size: 64,
                  color: Colors.blueGrey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            climateModel.temperature.celsiusLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip(
                'Max',
                climateModel.maxTemperature.celsiusLabel,
                Colors.red.shade600,
                Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                'Min',
                climateModel.minTemperature.celsiusLabel,
                Colors.blue.shade600,
                Icons.arrow_downward_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return RoundedContainer(
      color: color.withOpacity(0.12),
      borderRadius: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
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