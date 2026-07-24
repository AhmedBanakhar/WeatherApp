import 'package:climate/model/climate_model.dart';
import 'package:flutter/material.dart';

class ClimateInfoBody extends StatelessWidget {
  const ClimateInfoBody({super.key, required this.climateModel});
  final ClimateModel climateModel;

  @override
  Widget build(BuildContext context) {
    // حساب الساعة بنظام 12 ساعة وتحديد الفترة (صباحاً أو مساءً)
    final int hour12 = climateModel.date.hour % 12 == 0
        ? 12
        : climateModel.date.hour % 12;
    final String period = climateModel.date.hour >= 12 ? 'PM' : 'AM';

    // دمج الساعة والدقائق والفترة في متغير واحد
    final time =
        '${hour12.toString().padLeft(2, '0')}:${climateModel.date.minute.toString().padLeft(2, '0')} $period';

    return Card(
      elevation: 14,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: Colors.white.withValues(alpha: 0.96),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
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
                _WeatherIcon(iconUrl: climateModel.iconUrl),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '${climateModel.temperature.round()}°C',
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
                  '${climateModel.maxTemperature.round()}°C',
                  Colors.red.shade600,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  'Min',
                  '${climateModel.minTemperature.round()}°C',
                  Colors.blue.shade600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({super.key, required this.iconUrl});

  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.network(
        iconUrl,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(
            Icons.cloud,
            size: 40,
            color: Colors.blueGrey.shade400,
          ),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 90,
            height: 90,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
