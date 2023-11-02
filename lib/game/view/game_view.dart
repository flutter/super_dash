import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  static PageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const Game(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget.controlled(
          gameFactory: () => DashRunGame(
            gameBloc: context.read<GameBloc>(),
            audioController: context.read<AudioController>(),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: BlocSelector<GameBloc, GameState, int>(
            selector: (state) => state.score,
            builder: (context, score) {
              return Text(
                'Score: $score',
                style: Theme.of(context).textTheme.displaySmall,
              );
            },
          ),
        ),
      ],
    );
  }
}
