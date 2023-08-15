import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class Player extends PositionedEntity
    with HasGameRef<FixedResolutionFlameGame> {
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

  late SpriteAnimationComponent runningAnimation;
  late SpriteComponent flyingSprite;

  double yVelocity = 0;

  static final _size = Vector2.all(100);

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

    final animation = await gameRef.loadSpriteAnimation(
      'running_character.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: .2,
        textureSize: Vector2.all(32),
      ),
    );
    runningAnimation = SpriteAnimationComponent(
      animation: animation,
      size: size,
    );

    final flyingSpriteImage = await gameRef.loadSprite('flying_character.png');
    flyingSprite = SpriteComponent(
      sprite: flyingSpriteImage,
      size: size,
    );

    add(runningAnimation);

    position = Vector2(
      200,
      gameRef.resolution.y - DashRunGame.floorSize,
    );
  }

  void jump() {
    findBehavior<JumpingBehavior>().jump();
  }
}
