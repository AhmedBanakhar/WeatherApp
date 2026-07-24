import 'package:flutter/material.dart';

/// A [Container] with a solid background colour and rounded corners, used for
/// the app's chips, pills and icon badges.
class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    required this.color,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final Color color;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
