import 'dart:async';
import 'dart:ui';

import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Player extends JumperCharacter<DashRunGame> {
  Player({
    required this.levelSize,
    required this.cameraViewport,
    super.health = initialHealth,
  });

  static const initialHealth = 1;

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  late Vector2 spawn;
  late final List<Vector2> respawnPoints;
  late final SimpleCombinedInput input;
  late final PlayerCameraAnchor cameraAnchor;

  List<ItemType> powerUps = [];
  bool isPlayerInvincible = false;
  bool isPlayerTeleporting = false;

  bool get doubleJumpEnabled => powerUps.contains(ItemType.goldenFeather);

  double? _respawnTimer;

  double? _hasJumpedTimer;

  @override
  int get priority => 1;

  @override
  set jumping(bool value) {
    if (!super.jumping && value) {
      final jumpSound = doubleJumpEnabled ? Sfx.phoenixJump : Sfx.jump;
      gameRef.audioController.playSfx(jumpSound);
      gameRef.audioController.playSfx(Sfx.jump);

      final newJumpState =
          powerUps.isEmpty ? DashState.jump : DashState.phoenixJump;
      findBehavior<PlayerStateBehavior>().state = newJumpState;

      _hasJumpedTimer = .4;
    }

    super.jumping = value;
  }

  void doubleJump() {
    super.jumping = true;
    gameRef.audioController.playSfx(Sfx.doubleJump);
    findBehavior<PlayerStateBehavior>().state = DashState.phoenixDoubleJump;
  }

  @override
  set walking(bool value) {
    if (!super.walking && value) {
      findBehavior<PlayerStateBehavior>().state =
          powerUps.isEmpty ? DashState.running : DashState.phoenixRunning;
    } else if (super.walking && !value) {
      findBehavior<PlayerStateBehavior>().state =
          powerUps.isEmpty ? DashState.idle : DashState.phoenixIdle;
    }

    super.walking = value;
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

    add(cameraAnchor);
    add(PlayerControllerBehavior());
    add(PlayerStateBehavior());

    gameRef.camera.follow(cameraAnchor);

    loadSpawnPoint();

    final respawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('respawn');
    respawnPoints = [
      ...respawnGroup.objects.map(
        (object) => Vector2(object.x, object.y),
      ),
    ];
  }

  void loadSpawnPoint() {
    final spawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawnGroup.objects) {
      position = Vector2(object.x, object.y);
      spawn = position.clone();
    }
  }

  void addPowerUp(ItemType type) {
    powerUps.add(type);

    final behavior = findBehavior<PlayerStateBehavior>();
    if (behavior.state == DashState.idle) {
      behavior.state = DashState.phoenixIdle;
    } else if (behavior.state == DashState.running) {
      behavior.state = DashState.phoenixRunning;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_respawnTimer != null) {
      _respawnTimer = _respawnTimer! - dt;
      if (_respawnTimer! <= 0) {
        _respawnTimer = null;
        gameRef.gameOver();
      }
      return;
    }

    if (isPlayerTeleporting) return;

    if (_hasJumpedTimer != null) {
      _hasJumpedTimer = _hasJumpedTimer! - dt;

      if (_hasJumpedTimer! <= 0 && collisionInfo.downCollision != null) {
        findBehavior<PlayerStateBehavior>().state =
            powerUps.isEmpty ? DashState.running : DashState.phoenixRunning;
        _hasJumpedTimer = null;
      }
    }

    if (collisionInfo.downCollision != null && velocity.x > 0) {
      gameRef.audioController.startBackgroundSfx();
    } else {
      gameRef.audioController.stopBackgroundSfx();
    }

    if ((gameRef.isLastSection && x >= gameRef.leapMap.width - tileSize) ||
        (!gameRef.isLastSection &&
            x >= gameRef.leapMap.width - gameRef.tileSize * 15)) {
      sectionCleared();
      return;
    }

    if (isDead) {
      findBehavior<PlayerStateBehavior>().state = DashState.deathFaint;
      super.walking = false;
      _respawnTimer = 1.4;
      return;
    }

    // Player falls in a hazard zone.
    if ((collisionInfo.downCollision?.tags.contains('hazard') ?? false) &&
        !isPlayerInvincible) {
      // If player has no golden feathers, game over.
      if (powerUps.isEmpty) {
        findBehavior<PlayerStateBehavior>().state = DashState.deathPit;
        _respawnTimer = 1.4;
        return;
        //return game.gameOver();
      }

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
            gameRef.audioController.playSfx(
              collision.type == ItemType.acorn
                  ? Sfx.acornPickup
                  : Sfx.eggPickup,
            );
            gameRef.gameBloc.add(
              GameScoreIncreased(by: collision.type.points),
            );
          case ItemType.goldenFeather:
            addPowerUp(ItemType.goldenFeather);
            gameRef.audioController.playSfx(Sfx.featherPowerup);
        }
        collision.removeFromParent();
      }

      if (collision is Enemy && !isPlayerInvincible) {
        health -= collision.enemyDamage;
      }
    }
  }

  void spritePaintColor(Color color) {
    findBehavior<PlayerStateBehavior>().updateSpritePaintColor(color);
  }

  void sectionCleared() {
    isPlayerTeleporting = true;
    gameRef.sectionCleared();
  }
}
