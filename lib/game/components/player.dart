import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class PlayerCameraAnchor extends Component
    with ParentIsA<PositionComponent>
    implements ReadOnlyPositionProvider {
  PlayerCameraAnchor({
    required this.levelSize,
    required this.cameraViewport,
  });

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  final Vector2 _anchor = Vector2.zero();

  late final Vector2 _cameraMin = Vector2(
    cameraViewport.x / 2,
    cameraViewport.y / 2,
  );

  late final Vector2 _cameraMax = Vector2(
    levelSize.x - cameraViewport.x / 2,
    levelSize.y - cameraViewport.y / 2,
  );

  @override
  Vector2 get position => _anchor;

  void _setAnchor(double x, double y) {
    _anchor
      ..x = x.clamp(_cameraMin.x, _cameraMax.x)
      ..y = y.clamp(_cameraMin.y, _cameraMax.y);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final value = parent.position.clone();
    _setAnchor(value.x, value.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _setAnchor(
      parent.position.x,
      parent.position.y,
    );
  }
}

class Player extends JumperCharacter<DashRunGame> {
  Player({
    required this.levelSize,
    required this.cameraViewport,
    super.health = initialHealth,
  });

  static const initialHealth = 1;

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  late final Vector2 spawn;
  late final SimpleCombinedInput input;
  late final PlayerCameraAnchor cameraAnchor;

  List<Item> powerUps = [];

  @override
  int get priority => 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    input = gameRef.input;
    size = Vector2.all(gameRef.tileSize);
    walkSpeed = gameRef.tileSize * 5;
    minJumpImpulse = world.gravity * 0.7;
    cameraAnchor = PlayerCameraAnchor(
      cameraViewport: cameraViewport,
      levelSize: levelSize,
    );

    add(cameraAnchor);
    add(PlayerControllerBehavior());
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

    if (isDead) return game.gameOver();

    if (collisionInfo.downCollision?.isHazard ?? false) {
      if (powerUps.isEmpty) return game.gameOver();
      powerUps.removeLast();

      // Respawn player at the last safe ground position.
      final LeapMapGroundTile(:gridX, :gridY) = collisionInfo.downCollision!;

      // We set an offset of 5 tiles to the left assuming that there is a tile
      // where the player can stand in the previous 5 tiles from where he hit.
      const offset = 5;
      for (var i = 0; i < offset; i++) {
        // We assume that this tile is not null
        // based on the hazard zones of the map.
        final LeapMapGroundTile(
          :isHazard,
          position: tilePosition,
        ) = game.leapMap.groundTiles[gridX - i][gridY]!;

        // If is not a hazard, we can respawn the player here.
        // We need to also set the y position to the top of the tile.
        if (!isHazard) {
          position.setValues(
            tilePosition.x,
            tilePosition.y - game.tileSize,
          );
        }
      }
    }

    final collisions = collisionInfo.otherCollisions ?? const [];

    if (collisions.isEmpty) return;

    for (final collision in collisions) {
      if (collision is Item) {
        switch (collision.type) {
          case ItemType.acorn || ItemType.egg:
            game.score += collision.type.points;
          case ItemType.goldenFeather || ItemType.wings:
            powerUps.add(collision);
        }
        collision.removeFromParent();
      }

      if (collision is Enemy) {
        health -= collision.enemyDamage;
      }
    }
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
