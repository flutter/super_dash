import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    const titleColor = Color(0xFF18274C);

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
            Text(
              l10n.gameOver,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              l10n.betterLuckNextTime,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: titleColor,
                  ),
            ),
            const Spacer(flex: 4),
            Text(
              l10n.totalScore,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(flex: 2),
            _ScoreWidget(score),
            const Spacer(flex: 4),
            GameElevatedButton(
              label: l10n.submitScore,
              onPressed: () {
                // TODO(all): navigate to score submission.
              },
            ),
            const Spacer(flex: 3),
            GameElevatedButton(
              label: l10n.playAgain,
              onPressed: () {
                Navigator.of(context).pop();
              },
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFA6C3DF),
                  Color(0xFF79AACA),
                ],
              ),
            ),
            const Spacer(flex: 40),
            const BottomBar(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget(this.score);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x80EAFFFE),
            Color(0x80C9D9F1),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.trophy.image(width: 40, height: 40),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF4D5B92),
                    fontWeight: FontWeight.bold,
                  ),
              children: [
                TextSpan(text: '${formatScore(score)} '),
                const TextSpan(
                  text: 'Pts',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatScore(int score) {
    final formatter = NumberFormat('#,###');
    return formatter.format(score);
  }
}
