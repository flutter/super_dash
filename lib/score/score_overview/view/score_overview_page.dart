import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/score/score.dart';
import 'package:super_dash/utils/utils.dart';

class ScoreOverviewPage extends StatelessWidget {
  const ScoreOverviewPage({super.key});

  static Page<void> page() {
    return const MaterialPage<void>(
      child: ScoreOverviewPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWithBackground(
      background: const GameBackground(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.gameOverBg.provider(),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black38,
              BlendMode.darken,
            ),
            alignment:
                isDesktop ? const Alignment(0, .7) : Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AppCard(
                border: Border.all(color: Colors.white30),
                child: const _Content(),
              ),
            ),
            const Spacer(),
            const BottomBar(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const initialsColor = Color(0xFFA7EED2);
    final initials = context.select((ScoreBloc bloc) => bloc.state.initials);

    return Column(
      children: [
        Assets.images.dashWins.image(height: 160),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.shareYourScore,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(flex: 2),
        Text(
          initials.join(),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
            color: initialsColor,
          ),
        ),
        const Spacer(flex: 2),
        const _ScoreWidget(),
        const Spacer(flex: 4),
        if (kIsWeb) const WebButtons() else const MobileButtons(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final score = context.select((ScoreBloc bloc) => bloc.score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(81, 177, 177, 177),
            Color.fromARGB(51, 54, 53, 103),
            Color.fromARGB(137, 27, 27, 54),
          ],
          stops: [0.05, 0.5, 1],
        ),
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.trophy.image(width: 28, height: 28),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
              children: [
                TextSpan(text: '${formatScore(score)} '),
                const TextSpan(text: 'Pts'),
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
