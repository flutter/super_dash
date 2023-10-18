import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class PlayerCameraAnchor extends Component
    with ParentIsA<Player>
    implements ReadOnlyPositionProvider {
  late final Vector2 _anchor;

  @override
  Vector2 get position => _anchor;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _anchor = parent.position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _anchor
      ..x = parent.position.x
      ..y = parent.position.y - 200;
  }
}

class Player extends JumperCharacter<DashRunGame> {
  Player({super.health = initialHealth});

  static const initialHealth = 3;

  late final Vector2 spawn;
  late final SimpleCombinedInput input;
  late final PlayerCameraAnchor cameraAnchor;

  final List<Item> items = [];

  @override
  int get priority => 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    input = gameRef.input;
    size = Vector2.all(gameRef.tileSize);
    walkSpeed = gameRef.tileSize * 7;
    minJumpImpulse = world.gravity * 0.6;
    cameraAnchor = PlayerCameraAnchor();

    add(cameraAnchor);
    add(PlayerCollidingBehavior());
    add(PlayerKeyboardControllerBehavior());
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
      ),
    );

    gameRef.camera.follow(cameraAnchor);

    final spawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawnGroup.objects) {
      position = Vector2(object.x, object.y);
      spawn = position.clone();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (world.isOutside(this)) resetPosition();
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
}
