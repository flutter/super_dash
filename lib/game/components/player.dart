import 'dart:async';

import 'package:dash_run/game/game.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class Player extends JumperCharacter {
  Player();

  double yVelocity = 0;

  @override
  int get priority => 1;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(gameRef.tileSize);

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
      ),
    );

    final hitbox = RectangleHitbox.relative(
      Vector2.all(.8),
      parentSize: size,
    );

    add(hitbox);
    add(PropagatingCollisionBehavior(hitbox));

    final spawn = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawn.objects) {
      position = Vector2(object.x, object.y);
    }
  }

  void jump() => findBehavior<JumpingBehavior>().jump();
}
