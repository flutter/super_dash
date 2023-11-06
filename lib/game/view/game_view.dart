import 'package:app_ui/app_ui.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            gameFactory: () => DashRunGame(
              gameBloc: context.read<GameBloc>(),
              audioController: context.read<AudioController>(),
            ),
          ),
          const Positioned(
            top: 12,
            child: ScoreLabel(),
          ),
          const Positioned(
            bottom: 12,
            child: SoundControl(),
          ),
        ],
      ),
    );
  }
}

class SoundControl extends StatelessWidget {
  const SoundControl({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return SafeArea(
      child: ValueListenableBuilder<bool>(
        valueListenable: settingsController.muted,
        builder: (context, muted, child) => GameIconButton(
          icon: muted ? Icons.volume_up : Icons.volume_off,
          onPressed: context.read<SettingsController>().toggleMuted,
        ),
      ),
    );
  }
}
