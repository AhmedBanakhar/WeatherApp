import 'package:flutter/material.dart';

/// A rounded, elevated [Card] with the padding and spacing shared across the
/// app's content cards.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.elevation = 8,
    this.borderRadius = 24,
    this.bottomMargin = 20,
    this.color,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final double elevation;
  final double borderRadius;
  final double bottomMargin;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color,
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Padding(padding: padding, child: child),
    );
  }
}
