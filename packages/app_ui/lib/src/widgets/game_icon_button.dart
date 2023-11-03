import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// {@template game_icon_button}
/// Common icon button for the screens in the game.
/// {@endtemplate}
class GameIconButton extends StatelessWidget {
  /// {@macro game_icon_button}
  const GameIconButton({
    required this.icon,
    this.onPressed,
    this.gradient,
    super.key,
  });

  /// The icon to display.
  final IconData icon;

  /// The callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The colors gradient to use for the button.
  final List<Color>? gradient;

  static const _defaultGradient = LinearGradient(
    colors: [
      Color(0xFFB1B1B1),
      Color(0xFF363567),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return TraslucentBackground(
      gradient: gradient ?? _defaultGradient.colors,
      border: Border.all(
        color: Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(14),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
