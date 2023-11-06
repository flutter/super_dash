import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
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
    final l10n = context.l10n;

    return PageWithBackground(
      background: const GameBackground(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.gameOverBackground.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 15),
            Text(l10n.gameOver),
            Text(l10n.betterLuckNextTime),
            const Spacer(flex: 4),
            Text(l10n.totalScore),
            const Spacer(flex: 2),
            GameElevatedButton(label: '$score Pts'),
            const Spacer(flex: 4),
            GameElevatedButton(label: l10n.submitScore),
            const Spacer(flex: 3),
            GameElevatedButton(label: l10n.playAgain),
            const Spacer(flex: 40),
            const BottomBar(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
