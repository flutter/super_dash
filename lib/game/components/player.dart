import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';

class Player extends PositionedEntity with HasGameRef<DashRunGame> {
  Player()
      : super(
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox.relative(
                Vector2.all(.8),
                parentSize: _size,
              ),
            ),
            GravityBehavior(),
            PlayerKeyboardControllerBehavior(),
            JumpingBehavior(),
            FlyingBehavior(),
            PlayerCollidingBehavior(),
          ],
        );

  static final _size = Vector2.all(100);

  late final SpriteComponent flyingSprite;
  late final SpriteAnimationComponent runningAnimation;

  double yVelocity = 0;

  @override
  int get priority => 1;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    size = _size;

    add(
      RectangleHitbox.relative(
        Vector2.all(.8),
        parentSize: size,
      ),
    );

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
      ),
    );

    position = Vector2(
      200,
      gameRef.resolution.y - DashRunGame.floorSize,
    );
  }

  void jump() => findBehavior<JumpingBehavior>().jump();
}
