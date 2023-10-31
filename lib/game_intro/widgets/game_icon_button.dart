import 'package:flutter/material.dart';

class GameIconButton extends StatelessWidget {
  const GameIconButton({
    required this.icon,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB1B1B1),
                    Color(0xFF363567),
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
