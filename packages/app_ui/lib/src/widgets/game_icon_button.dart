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
    this.border,
    this.size,
    this.alignment,
    super.key,
  });

  /// The icon to display.
  final IconData icon;

  /// The callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The colors gradient to use for the button.
  final List<Color>? gradient;

  /// The border to use for the button.
  final Border? border;

  /// The size of the icon.
  final double? size;

  /// The alignment of the icon.
  final Alignment? alignment;

  static const _defaultGradient = LinearGradient(
    colors: [
      Color(0xFFB1B1B1),
      Color(0xFF363567),
    ],
  );

  static final _defaultBorder = Border.all(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return TraslucentBackground(
      gradient: gradient ?? _defaultGradient.colors,
      border: border ?? _defaultBorder,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(14),
          alignment: alignment ?? Alignment.center,
          child: Icon(
            icon,
            size: size ?? 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
