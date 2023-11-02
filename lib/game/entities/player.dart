import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leap/leap.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

class Player extends JumperCharacter<SuperDashGame> {
  Player({
    required this.levelSize,
    required this.cameraViewport,
    super.health = initialHealth,
  });

  static const initialHealth = 1;

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  late final Vector2 spawn;
  late final List<Vector2> respawnPoints;
  late final SimpleCombinedInput input;
  late final PlayerCameraAnchor cameraAnchor;
  late final SpriteAnimationComponent runningAnimation;

  List<ItemType> powerUps = [];
  bool isPlayerInvincible = false;
  bool isPlayerTeleporting = false;

  bool get doubleJumpEnabled => powerUps.contains(ItemType.goldenFeather);

  @override
  int get priority => 1;

  @override
  set jumping(bool value) {
    if (!super.jumping && value) {
      gameRef.audioController.playSfx(Sfx.jump);
    }

    super.jumping = value;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    input = gameRef.input;
    size = Vector2.all(gameRef.tileSize * .5);
    walkSpeed = gameRef.tileSize * 5;
    minJumpImpulse = world.gravity * 0.5;
    cameraAnchor = PlayerCameraAnchor(
      cameraViewport: cameraViewport,
      levelSize: levelSize,
    );

    final animation = await gameRef.loadSpriteAnimation(
      'anim/spritesheet_dash_run.png',
      SpriteAnimationData.sequenced(
        amount: 32,
        stepTime: 0.042,
        textureSize: Vector2.all(gameRef.tileSize),
        amountPerRow: 8,
      ),
    );

    runningAnimation = SpriteAnimationComponent(
      size: Vector2.all(gameRef.tileSize),
      animation: animation,
      anchor: Anchor.center,
      position: size / 2 - Vector2(0, size.y / 2),
    );

    add(runningAnimation);
    add(cameraAnchor);
    add(PlayerControllerBehavior());

    gameRef.camera.follow(cameraAnchor);

    final spawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawnGroup.objects) {
      position = Vector2(object.x, object.y);
      spawn = position.clone();
    }

    final respawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('respawn');
    respawnPoints = [
      ...respawnGroup.objects.map(
        (object) => Vector2(object.x, object.y),
      ),
    ];
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlayerTeleporting) return;

    if (x >= gameRef.leapMap.width - gameRef.tileSize) {
      levelCleared();
      return;
    }

    if (isDead) return game.gameOver();

    // Player falls in a hazard zone.
    if ((collisionInfo.downCollision?.tags.contains('hazard') ?? false) &&
        !isPlayerInvincible) {
      // If player has no golden feathers, game over.
      if (powerUps.isEmpty) return game.gameOver();

      // If player has a golden feather, use it to avoid death.
      powerUps.removeLast();

      // Get the position of the tile below the player that cause them to die.
      final hazardPosition = collisionInfo.downCollision!.position;

      // Get closest value to gridX and gridY in respawnPoints.
      final closestRespawn = respawnPoints.reduce((a, b) {
        return (a - hazardPosition).length2 < (b - hazardPosition).length2
            ? a
            : b;
      });

      // Set player position to closest respawn point.
      return hazardPosition.setValues(closestRespawn.x, closestRespawn.y);
    }

    final collisions = collisionInfo.otherCollisions ?? const [];

    if (collisions.isEmpty) return;

    for (final collision in collisions) {
      if (collision is Item) {
        switch (collision.type) {
          case ItemType.acorn || ItemType.egg:
            game.score += collision.type.points;
          case ItemType.goldenFeather:
            powerUps.add(ItemType.goldenFeather);
        }
        collision.removeFromParent();
      }

      if (collision is Enemy && !isPlayerInvincible) {
        health -= collision.enemyDamage;
      }
    }
  }

  void levelCleared() {
    isPlayerTeleporting = true;
    gameRef.levelCleared();

    walking = false;
    velocity
      ..x = 0
      ..y = 0;
    lastGroundXVelocity = 0;
    faceLeft = false;

    runningAnimation.add(
      MoveEffect.by(
        Vector2(0, -gameRef.tileSize * 2),
        CurvedEffectController(
          .5,
          Curves.easeOutCubic,
        ),
        onComplete: () async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          runningAnimation.add(
            SequenceEffect(
              [
                ScaleEffect.to(
                  Vector2(-1, 1),
                  CurvedEffectController(
                    .1,
                    Curves.easeIn,
                  ),
                ),
                ScaleEffect.to(
                  Vector2(0, 1),
                  CurvedEffectController(
                    .1,
                    Curves.easeOut,
                  ),
                ),
              ],
              onComplete: () async {
                position = spawn.clone();
                await Future<void>.delayed(const Duration(milliseconds: 200));

                runningAnimation
                  ..position = size / 2
                  ..add(
                    SequenceEffect(
                      [
                        ScaleEffect.to(
                          Vector2(-1, 1),
                          CurvedEffectController(
                            .1,
                            Curves.easeIn,
                          ),
                        ),
                        ScaleEffect.to(
                          Vector2.all(1),
                          CurvedEffectController(
                            .1,
                            Curves.easeOut,
                          ),
                        ),
                      ],
                      onComplete: () {
                        isPlayerTeleporting = false;
                      },
                    ),
                  );
              },
            ),
          );
        },
      ),
    );
  }
}
