import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GameView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: GameWidget.controlled(
        gameFactory: () => SuperDashGame(
          audioController: context.read<AudioController>(),
        ),
      ),
    );
  }
}
