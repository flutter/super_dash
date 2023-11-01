import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  GameButton({
    required String label,
    VoidCallback? onPressed,
    super.key,
  }) : _child = ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        );

  GameButton.icon({
    required String label,
    required Icon icon,
    VoidCallback? onPressed,
    super.key,
  }) : _child = ElevatedButton.icon(
          icon: icon,
          label: Text(label),
          onPressed: onPressed,
        );

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFA7EED2),
            Color(0xFF0ACDB3),
          ],
        ),
        borderRadius: BorderRadius.circular(94),
      ),
      child: Theme(
        data: theme.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(94),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 72,
                vertical: 16,
              ),
              textStyle: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        child: _child,
      ),
    );
  }
}
