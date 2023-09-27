import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

abstract class FixedResolutionGame extends LeapGame {
  FixedResolutionGame({
    required super.tileSize,
    required this.resolution,
  });

  final Vector2 resolution;

  @mustCallSuper
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await loadWorldAndMap(
      tiledMapPath: Assets.tiles.mapV01,
      tileCameraWidth: resolution.x.toInt(),
      tileCameraHeight: resolution.y.toInt(),
      prefix: '',
    );
  }
}

class DashRunGame extends FixedResolutionGame
    with TapCallbacks, HasKeyboardHandlerComponents, HasCollisionDetection {
  DashRunGame()
      : super(
          tileSize: 32,
          resolution: Vector2(40, 10),
        );

  static const floorSize = 220.0;

  int score = 0;

  late final Player player;
  late final Enemies enemies;
  late final SimpleCombinedInput input;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // player = Player();
    // await world.addAll([player, ScoreLabel(), SimpleCombinedInput()]);
    // camera.follow(player);

    // enemies = Enemies();
    // await enemies.addAllToMap(leapMap);
  }

  void gameOver() {
    score = 0;
    world.firstChild<Player>()?.removeFromParent();
    world.removeWhere((child) => child is Enemies);

    Future<void>.delayed(
      const Duration(seconds: 1),
      () => world.add(Player()),
    );
  }
}
