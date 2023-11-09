import 'dart:async';
import 'dart:ui';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

enum DashState {
  idle,
  running,

  phoenixIdle,
  phoenixRunning,

  deathPit,
  deathFaint,

  jump,
  phoenixJump,

  phoenixDoubleJump,
}

class PlayerStateBehavior extends Behavior<Player> {
  DashState? _state;

  late final Map<DashState, PositionComponent> _stateMap;

  DashState get state => _state ?? DashState.idle;

  static const _needResetStates = {
    DashState.deathPit,
    DashState.deathFaint,
    DashState.jump,
    DashState.phoenixJump,
    DashState.phoenixDoubleJump,
  };

  void updateSpritePaintColor(Color color) {
    for (final component in _stateMap.values) {
      if (component is HasPaint) {
        (component as HasPaint).paint.color = color;
      }
    }
  }

  void fadeOut({VoidCallback? onComplete}) {
    final component = _stateMap[state];
    if (component != null && component is HasPaint) {
      component.add(
        OpacityEffect.fadeOut(
          EffectController(duration: .5),
          onComplete: onComplete,
        ),
      );
    }
  }

  void fadeIn({VoidCallback? onComplete}) {
    final component = _stateMap[state];
    if (component != null && component is HasPaint) {
      component.add(
        OpacityEffect.fadeIn(
          EffectController(duration: .5, startDelay: .8),
          onComplete: onComplete,
        ),
      );
    }
  }

  set state(DashState state) {
    if (state != _state) {
      final current = _stateMap[_state];

      if (current != null) {
        current.removeFromParent();

        if (_needResetStates.contains(_state)) {
          if (current is SpriteAnimationComponent) {
            current.animationTicker?.reset();
          }
        }
      }

      final replacement = _stateMap[state];
      if (replacement != null) {
        parent.add(replacement);
      }
      _state = state;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final [
      idleAnimation,
      runningAnimation,
      phoenixIdleAnimation,
      phoenixRunningAnimation,
      deathPitAnimation,
      deathFaintAnimation,
      jumpAnimation,
      phoenixJumpAnimation,
      phoenixDoubleJumpAnimation,
    ] = await Future.wait(
      [
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_dash_idle.png',
          SpriteAnimationData.sequenced(
            amount: 18,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_dash_run.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_phoenixDash_idle.png',
          SpriteAnimationData.sequenced(
            amount: 18,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_phoenixDash_run.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_dash_deathPit.png',
          SpriteAnimationData.sequenced(
            amount: 24,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_dash_deathFaint.png',
          SpriteAnimationData.sequenced(
            amount: 24,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_dash_jump.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_phoenixDash_jump.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 0.042,
            textureSize: Vector2(
              parent.gameRef.tileSize,
              parent.gameRef.tileSize * 2,
            ),
            amountPerRow: 8,
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/spritesheet_phoenixDash_doublejump.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 0.042,
            textureSize: Vector2.all(parent.gameRef.tileSize),
            amountPerRow: 8,
            loop: false,
          ),
        ),
      ],
    );

    final centerPosition = parent.size / 2 - Vector2(0, parent.size.y / 2);
    _stateMap = {
      DashState.idle: SpriteAnimationComponent(
        animation: idleAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.running: SpriteAnimationComponent(
        animation: runningAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.phoenixIdle: SpriteAnimationComponent(
        animation: phoenixIdleAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.phoenixRunning: SpriteAnimationComponent(
        animation: phoenixRunningAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.deathPit: SpriteAnimationComponent(
        animation: deathPitAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.deathFaint: SpriteAnimationComponent(
        animation: deathFaintAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.jump: SpriteAnimationComponent(
        animation: jumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.phoenixJump: SpriteAnimationComponent(
        animation: phoenixJumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
      DashState.phoenixDoubleJump: SpriteAnimationComponent(
        animation: phoenixDoubleJumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
      ),
    };

    state = DashState.idle;
  }
}
