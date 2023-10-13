import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Player extends PositionedEntity with HasGameRef<DashRunGame> {
  late final SpriteAnimationComponent spriteAnimation;

  double yVelocity = 0;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(gameRef.tileSize);

    add(
      RectangleHitbox.relative(
        Vector2.all(.8),
        parentSize: size,
      ),
    );

    add(
      PropagatingCollisionBehavior(
        RectangleHitbox.relative(
          Vector2.all(.8),
          parentSize: size,
        ),
      ),
    );

    final animation = await gameRef.loadSpriteAnimation(
      Assets.images.runningCharacter.path,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: .2,
        textureSize: Vector2.all(32),
      ),
    );

    spriteAnimation = SpriteAnimationComponent(
      size: size,
      animation: animation,
    );

    final playerSpawn = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final spawn in playerSpawn.objects) {
      position = Vector2(spawn.x, spawn.y);
    }
  }

  void jump() => findBehavior<JumpingBehavior>().jump();
}
