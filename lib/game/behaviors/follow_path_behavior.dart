import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:leap/leap.dart';
import 'package:pathxp/pathxp.dart';

class FollowPathBehavior extends Behavior<PhysicalEntity> {
  FollowPathBehavior(this.pathExpression);

  final Pathxp pathExpression;

  bool _facingLeft = true;
  late double _lastParentX;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _lastParentX = parent.x;

    const speed = 3.0;

    final tileSize = parent.gameRef.tileSize;

    final steps = [...pathExpression.path.path];

    final effects = <MoveEffect>[];
    var step = steps.removeAt(0);
    var stepPosition = step.toOffset(tileSize);

    final vectorers = <Vector2>[];

    while (steps.isNotEmpty) {
      final nextStep = steps.removeAt(0);

      if (nextStep != step) {
        effects.add(
          stepPosition.toMoveEffect(
            tileSize: tileSize,
            baseSpeed: speed,
          ),
        );
        vectorers.add(stepPosition);
        stepPosition = Vector2.zero();
      }

      stepPosition = stepPosition + nextStep.toOffset(tileSize);
      step = nextStep;
    }

    if (stepPosition.x != 0 || stepPosition.y != 0) {
      effects.add(
        stepPosition.toMoveEffect(
          tileSize: tileSize,
          baseSpeed: speed,
        ),
      );
      vectorers.add(stepPosition);
    }

    parent.add(
      SequenceEffect(
        effects,
        infinite: pathExpression.path.infinite,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final currentParentX = parent.x;

    if (currentParentX != _lastParentX) {
      final newFacingLeft = currentParentX < _lastParentX;

      if (_facingLeft != newFacingLeft) {
        _facingLeft = newFacingLeft;

        _flipParentSprite();
      }
    }

    _lastParentX = currentParentX;
  }

  void _flipParentSprite() {
    final sprite = parent.firstChild<SpriteComponent>() ??
        parent.firstChild<SpriteAnimationComponent>();

    if (sprite != null) {
      sprite.flipHorizontallyAroundCenter();
    }
  }
}

extension on Vector2 {
  MoveEffect toMoveEffect({
    required double tileSize,
    required double baseSpeed,
  }) {
    final totalSpeed = length / tileSize * baseSpeed;
    return MoveEffect.by(
      this,
      LinearEffectController(
        totalSpeed,
      ),
    );
  }
}

extension on PathDirection {
  Vector2 toOffset(double tileSize) {
    return switch (this) {
      PathDirection.T => Vector2(0, -tileSize),
      PathDirection.B => Vector2(0, tileSize),
      PathDirection.L => Vector2(-tileSize, 0),
      PathDirection.R => Vector2(tileSize, 0),
    };
  }
}
