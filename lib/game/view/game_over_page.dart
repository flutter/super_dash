import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/widgets/widgets.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.gameBackground.image(
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Game over!'),
              Text('Better luck next time.'),
              Text('Total Score'),
              const ScoreLabel(),
              GameElevatedButton(
                label: 'Submit score',
                onPressed: () {},
              ),
              GameElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: 'Play again',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
