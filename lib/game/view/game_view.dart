import 'package:dash_run/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: GameWidget.controlled(
        gameFactory: DashRunGame.new,
      ),
    );
  }
}
