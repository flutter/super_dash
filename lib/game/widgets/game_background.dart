import 'package:flutter/material.dart';
import 'package:super_dash/gen/assets.gen.dart';

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
