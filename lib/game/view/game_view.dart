import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const GameView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget.controlled(
      loadingBuilder: (context) => const GameBackground(),
      backgroundBuilder: (context) => const GameBackground(),
      gameFactory: () => DashRunGame(
        audioController: context.read<AudioController>(),
      ),
    );
  }
}
