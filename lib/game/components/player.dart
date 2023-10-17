import 'dart:async';

import 'package:dash_run/game/game.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class Player extends JumperCharacter<DashRunGame> {
  Player({super.health = initialHealth});

  static const initialHealth = 3;

  late final Vector2 spawn;
  late final SimpleCombinedInput input;
  final List<Item> items = [];

  @override
  int get priority => 1;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    input = gameRef.input;
    walkSpeed = map.tileSize * 2;
    minJumpImpulse = world.gravity * 0.6;
    size = Vector2.all(gameRef.tileSize);

    final hitbox = RectangleHitbox.relative(
      Vector2.all(.8),
      parentSize: size,
    );

    add(hitbox);
    add(PropagatingCollisionBehavior(hitbox));
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
      ),
    );
    add(GravityBehavior(gravity: world.gravity));
    add(PlayerCollidingBehavior());

    final spawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawnGroup.objects) {
      position = Vector2(object.x, object.y);
      spawn = position.clone();
    }
  }

  @override
  void update(double dt) {
    updateHandleInput(dt);

    if (isDead) {
      walking = false;
    }

    if (world.isOutside(this)) {
      resetPosition();
    }

    velocity
      ..x = walkSpeed
      ..y += world.gravity * dt;

    return super.update(dt);
  }

  void resetPosition() {
    x = spawn.x;
    y = spawn.y;
    velocity
      ..x = 0
      ..y = 0;
    lastGroundXVelocity = 0;
    faceLeft = false;
  }

  void updateHandleInput(double dt) {
    if (isAlive) {
      // Keep jumping if started.
      if (jumping && input.isPressed) {
        jumping = true;
      } else {
        jumping = false;
      }
    }

    if (!input.justPressed) return;

    if (input.isPressedLeft) {
      // Tapped left.
      if (walking) {
        if (faceLeft) {
          // Already moving left.
          if (isOnGround) jumping = true;
        } else {
          // Moving right, stop.
          walking = false;
          faceLeft = true;
        }
      } else {
        // Standing still.
        walking = true;
        faceLeft = true;
      }
    }

    if (input.isPressedRight) {
      // Tapped right.
      if (walking) {
        if (!faceLeft) {
          // Already moving right.
          if (isOnGround) jumping = true;
        } else {
          // Moving left, stop.
          walking = false;
          faceLeft = false;
        }
      } else {
        // Standing still.
        walking = true;
        faceLeft = false;
      }
    }
  }
}
