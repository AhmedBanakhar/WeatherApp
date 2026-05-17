import 'package:flutter/material.dart';

class NoClimateBody extends StatelessWidget {
  const NoClimateBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_outlined,
              size: 72,
              color: Colors.blueGrey.shade200,
            ),
            const SizedBox(height: 18),
            Text(
              'Ready when you are',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start typing a city name above to see today’s weather.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
