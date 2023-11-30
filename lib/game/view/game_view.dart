import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const Game(),
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GameWidget.controlled(
            loadingBuilder: (context) => const GameBackground(),
            backgroundBuilder: (context) => const GameBackground(),
            gameFactory: () => SuperDashGame(
              gameBloc: context.read<GameBloc>(),
              audioController: context.read<AudioController>(),
            ),
            overlayBuilderMap: {
              'tapToJump': (context, game) => const TapToJumpOverlay(),
            },
            initialActiveOverlays: const ['tapToJump'],
          ),
          const Positioned(
            top: 12,
            child: ScoreLabel(),
          ),
          const Positioned(
            bottom: 12,
            child: SafeArea(child: AudioButton()),
          ),
        ],
      ),
    );
  }
}
