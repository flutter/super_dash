import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
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

    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    camera = CameraComponent.withFixedResolution(
      width: resolution.x,
      height: resolution.y,
    );
  }
}

class DashRunGame extends FixedResolutionGame
    with TapCallbacks, HasKeyboardHandlerComponents, HasCollisionDetection {
  DashRunGame({
    this.customBundle,
  }) : super(
          tileSize: 64,
          resolution: Vector2(2000, 1000),
        );

  static const prefix = 'assets/map/';

  late final Player player;
  late final Items items;
  late final Enemies enemies;
  late final SimpleCombinedInput input;

  final AssetBundle? customBundle;

  int score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images = Images(
      prefix: prefix,
      bundle: customBundle,
    );

    await loadWorldAndMap(
      camera: camera,
      images: images,
      prefix: prefix,
      bundle: customBundle,
      tiledMapPath: 'flutter_runnergame_map_v04.tmx',
    );

    input = SimpleCombinedInput();
    items = Items();
    enemies = Enemies();

    await addAll([items, enemies, input, ScoreLabel()]);

    player = Player();
    world.add(player);
  }

  void gameOver() {
    score = 0;
    world.firstChild<Player>()?.removeFromParent();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () => world.add(Player()),
    );
  }
}
