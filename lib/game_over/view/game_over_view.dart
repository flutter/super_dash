import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:flutter/material.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({required this.score, super.key});

  final int score;

  static PageRoute<void> route({required int score}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => GameOverPage(score: score),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWithBackground(
      background: const GameBackground(),
      child: Container(
        color: Colors.lightBlue,
        child: Column(
          children: [
            const Spacer(flex: 15),
            const Text('Game over!'),
            const Text('Better luck next time.'),
            const Spacer(flex: 4),
            const Text('Total Score'),
            const Spacer(flex: 2),
            GameElevatedButton(label: '$score Pts'),
            const Spacer(flex: 4),
            GameElevatedButton(label: 'Submit score'),
            const Spacer(flex: 3),
            GameElevatedButton(label: 'Play again'),
            const Spacer(flex: 40),
            const BottomBar(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
