import 'package:climate/widget/app_card.dart';
import 'package:climate/widget/rounded_container.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel = '',
    this.action,
  });

  final BuildContext context;
  final String title;
  final String subtitle;
  final IconData icon;
  final String actionLabel;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundedContainer(
            color: Colors.blueGrey.shade50,
            padding: const EdgeInsets.all(14),
            child: Icon(icon, size: 28, color: Colors.blueGrey.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: action,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(actionLabel),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
