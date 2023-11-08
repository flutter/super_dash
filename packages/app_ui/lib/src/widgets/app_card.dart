import 'package:flutter/material.dart';

/// {@template app_card}
/// An app themed card.
/// {@endtemplate}
class AppCard extends StatelessWidget {
  /// {@macro app_card}
  const AppCard({
    required this.child,
    this.backgroundColor = const Color(0xE51B1B36),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(81, 177, 177, 177),
        Color.fromARGB(51, 54, 53, 103),
        Color.fromARGB(230, 27, 27, 54),
      ],
      stops: [0.05, 0.5, 1],
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.border,
    super.key,
  });

  /// The content of the card.
  final Widget child;

  /// The background color of the card. Shown behind the [gradient].
  final Color? backgroundColor;

  /// The gradient of the card. Shown on top of the [backgroundColor].
  final LinearGradient? gradient;

  /// The border radius of the card.
  final BorderRadius? borderRadius;

  /// The border of the card.
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 328, maxHeight: 624),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
        color: backgroundColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: gradient,
        ),
        child: child,
      ),
    );
  }
}
