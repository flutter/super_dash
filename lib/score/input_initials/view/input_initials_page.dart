import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/score/score.dart';
import 'package:super_dash/utils/utils.dart';

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
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 3),
              SizedBox(
                height: 52,
                width: 52,
                child: TraslucentBackground(
                  gradient: const [
                    Color(0xFFB1B1B1),
                    Color(0xFF363567),
                  ],
                  border: Border.all(color: Colors.white),
                  child: const Align(
                    alignment: Alignment(-0.06, 0),
                    child: Icon(
                      FontAwesomeIcons.trophy,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your initials for\nthe leaderboard',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const InitialsFormView(),
              const Spacer(),
              const BottomBar(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
