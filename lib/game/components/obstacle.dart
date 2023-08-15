import 'package:dash_run/game/behaviors/behaviors.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionedEntity {
  Obstacle({
    super.position,
  }) : super(
          size: _size,
          behaviors: [
            ObstacleScrollingBehavior(),
          ],
          children: [
            RectangleComponent(
              size: _size,
              paint: Paint()..color = Colors.purple,
            ),
            RectangleHitbox.relative(
              Vector2.all(.8),
              parentSize: _size,
              collisionType: CollisionType.passive,
            ),
          ],
        );

  static final _size = Vector2(150, 150);
}
