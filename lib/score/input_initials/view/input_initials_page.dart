import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/score/score.dart';
import 'package:dash_run/utils/utils.dart';
import 'package:flutter/material.dart';

class InputInitialsPage extends StatelessWidget {
  const InputInitialsPage({super.key});

  static Page<void> page() {
    return const MaterialPage<void>(
      child: InputInitialsPage(),
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
            alignment:
                isDesktop ? const Alignment(0, .7) : Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            children: [
              Spacer(flex: 3),
              Text(
                'Enter your initials for\nthe leaderboard',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              InitialsFormView(),
              Spacer(),
              BottomBar(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
