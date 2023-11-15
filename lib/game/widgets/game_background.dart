import 'package:dash_run/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  const GameBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Assets.images.gameBackground.image(
        fit: BoxFit.cover,
      ),
    );
  }
}
