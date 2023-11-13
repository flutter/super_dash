import 'dart:async';

import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:leap/leap.dart';

class Player extends JumperCharacter<DashRunGame> {
  Player({
    required this.levelSize,
    required this.cameraViewport,
    super.health = initialHealth,
  });

  static const initialHealth = 1;
  static const speed = 5.0;
  static const jumpImpulse = .6;

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  late Vector2 spawn;
  late final List<Vector2> respawnPoints;
  late final PlayerCameraAnchor cameraAnchor;
  late final PlayerStateBehavior stateBehavior =
      findBehavior<PlayerStateBehavior>();

  List<ItemType> powerUps = [];
  bool isPlayerInvincible = false;
  bool isPlayerTeleporting = false;
  bool isPlayerRespawning = false;

  bool get doubleJumpEnabled => powerUps.contains(ItemType.goldenFeather);

  double? _gameOverTimer;

  double? _stuckTimer;
  double _dashPosition = 0;

  bool get isGoingToGameOver => _gameOverTimer != null;

  @override
  int get priority => 1;

  void jumpEffects() {
    final jumpSound = doubleJumpEnabled ? Sfx.phoenixJump : Sfx.jump;
    gameRef.audioController.playSfx(jumpSound);
    gameRef.audioController.playSfx(Sfx.jump);

    final newJumpState =
        powerUps.isEmpty ? DashState.jump : DashState.phoenixJump;
    stateBehavior.state = newJumpState;
  }

  void doubleJumpEffects() {
    gameRef.audioController.playSfx(Sfx.doubleJump);
    stateBehavior.state = DashState.phoenixDoubleJump;
  }

  @override
  set walking(bool value) {
    if (!super.walking && value) {
      setRunningState();
    } else if (super.walking && !value) {
      setIdleState();
    }

    super.walking = value;
  }

  void setRunningState() {
    final behavior = stateBehavior;
    if (behavior.state != DashState.running &&
        behavior.state != DashState.phoenixRunning) {
      final newRunState =
          powerUps.isEmpty ? DashState.running : DashState.phoenixRunning;
      if (behavior.state != newRunState) {
        behavior.state = newRunState;
      }
    }
  }

  void setIdleState() {
    stateBehavior.state =
        powerUps.isEmpty ? DashState.idle : DashState.phoenixIdle;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(gameRef.tileSize * .5);
    walkSpeed = gameRef.tileSize * speed;
    minJumpImpulse = world.gravity * jumpImpulse;
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

    if (stateBehavior.state == DashState.idle) {
      stateBehavior.state = DashState.phoenixIdle;
    } else if (stateBehavior.state == DashState.running) {
      stateBehavior.state = DashState.phoenixRunning;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameOverTimer != null) {
      _gameOverTimer = _gameOverTimer! - dt;
      if (_gameOverTimer! <= 0) {
        _gameOverTimer = null;
        gameRef.gameOver();
      }
      return;
    }

    _checkPlayerStuck(dt);

    if (isPlayerTeleporting) return;

    if ((gameRef.isLastSection && x >= gameRef.leapMap.width - tileSize) ||
        (!gameRef.isLastSection &&
            x >= gameRef.leapMap.width - gameRef.tileSize * 15)) {
      sectionCleared();
      return;
    }

    if (isDead) {
      return _animateToGameOver();
    }

    // Player falls in a hazard zone.
    if ((collisionInfo.downCollision?.tags.contains('hazard') ?? false) &&
        !isPlayerInvincible) {
      // If player has no golden feathers, game over.
      if (powerUps.isEmpty) {
        _animateToGameOver(DashState.deathPit);
        return;
      }

      // If player has a golden feather, use it to avoid death.
      powerUps.clear();
      return _respawn();
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
        gameRef.world.add(
          ItemEffect(
            type: collision.type,
            position: collision.position.clone(),
          ),
        );
        collision.removeFromParent();
      }

      if (collision is Enemy && !isPlayerInvincible) {
        // If player has no golden feathers, game over.
        if (powerUps.isEmpty) {
          health -= collision.enemyDamage;
          return;
        }

        // If player has a golden feather, use it to avoid death.
        powerUps.clear();
        return _respawn();
      }
    }
  }

  void _checkPlayerStuck(double dt) {
    final currentDashPosition = position.x;
    final isPlayerStopped = currentDashPosition == _dashPosition;
    // Player is set as walking but is not moving.
    if (walking && isPlayerStopped) {
      _stuckTimer ??= 1;
      _stuckTimer = _stuckTimer! - dt;
      if (_stuckTimer! <= 0) {
        _stuckTimer = null;
        health = 0;
      }
    } else {
      _stuckTimer = null;
    }
    _dashPosition = currentDashPosition;
  }

  void _animateToGameOver([DashState deathState = DashState.deathFaint]) {
    stateBehavior.state = deathState;
    super.walking = false;
    _gameOverTimer = 1.4;
  }

  void _respawn() {
    // Get closest value to gridX and gridY in respawnPoints.
    final closestRespawn = respawnPoints.reduce((a, b) {
      return (a - position).length2 < (b - position).length2 ? a : b;
    });

    isPlayerRespawning = true;
    isPlayerInvincible = true;
    walking = false;
    stateBehavior.fadeOut();
    add(
      MoveToEffect(
        closestRespawn.clone(),
        EffectController(
          curve: Curves.easeInOut,
          startDelay: .2,
          duration: .8,
        ),
      ),
    );
    stateBehavior.fadeIn(
      onComplete: () {
        isPlayerRespawning = false;
        isPlayerInvincible = false;
        walking = true;
      },
    );
  }

  void spritePaintColor(Color color) {
    stateBehavior.updateSpritePaintColor(color);
  }

  void sectionCleared() {
    isPlayerTeleporting = true;
    gameRef.sectionCleared();
  }
}
