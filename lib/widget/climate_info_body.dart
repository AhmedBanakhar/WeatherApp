import 'dart:ui';

import 'package:climate/model/climate_model.dart';
import 'package:flutter/material.dart';

class ClimateInfoBody extends StatelessWidget {
  const ClimateInfoBody({super.key, required this.climateModel});
  final ClimateModel climateModel;

  @override
  Widget build(BuildContext context) {
    // 12-hour clock with an AM/PM suffix.
    final int hour12 = climateModel.date.hour % 12 == 0
        ? 12
        : climateModel.date.hour % 12;
    final String period = climateModel.date.hour >= 12 ? 'PM' : 'AM';
    final time =
        '${hour12.toString().padLeft(2, '0')}:${climateModel.date.minute.toString().padLeft(2, '0')} $period';

    final radius = BorderRadius.circular(32);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.96),
                  Colors.white.withValues(alpha: 0.86),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            ),
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
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 22,
                                color: Colors.blueGrey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  climateModel.city,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Updated at $time',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              climateModel.weatherCondition,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey.shade50,
                      ),
                      child: Image.network(
                        'https:${climateModel.iconUrl}',
                        width: 84,
                        height: 84,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.wb_cloudy_rounded,
                          size: 64,
                          color: Colors.blueGrey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${climateModel.temperature.round()}°C',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 68,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatChip(
                      'Max',
                      '${climateModel.maxTemperature.round()}°C',
                      Colors.red.shade600,
                      Icons.arrow_upward_rounded,
                    ),
                    const SizedBox(width: 14),
                    _buildStatChip(
                      'Min',
                      '${climateModel.minTemperature.round()}°C',
                      Colors.blue.shade600,
                      Icons.arrow_downward_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
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
                  color: color.withValues(alpha: 0.9),
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