import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

abstract class FixedResolutionFlameGame extends FlameGame {
  FixedResolutionFlameGame({
    required this.resolution,
  });

  final Vector2 resolution;

  late World world;
  late CameraComponent gameCamera;

  @mustCallSuper
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    world = World();
    gameCamera = CameraComponent.withFixedResolution(
      world: world,
      width: resolution.x,
      height: resolution.y,
    )..viewfinder.position = resolution / 2;

    await add(world);
    await add(gameCamera);
  }
}

class DashRunGame extends FixedResolutionFlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DashRunGame()
      : super(
          resolution: Vector2(1400, 800),
        );

  static const floorSize = 220.0;

  int score = 0;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await world.addAll([
      Background(),
      Obstacles(),
      Player(),
      ScoreLabel(),
    ]);
  }

  void gameOver() {
    score = 0;
    world.firstChild<Player>()?.removeFromParent();
    world.removeWhere((child) => child is Obstacle);

    Future<void>.delayed(const Duration(seconds: 1), () {
      world.add(Player());
    });
  }
}
