import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Player extends PositionedEntity with HasGameRef<DashRunGame> {
  Player()
      : super(
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox.relative(
                Vector2.all(.8),
                parentSize: _size,
              ),
            ),
          ],
        );

  static final _size = Vector2.all(32);
  static final _images = Images(prefix: '');

  late final SpriteAnimationComponent runningAnimation;

  double yVelocity = 0;

  @override
  int get priority => 1;

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

    final animation = await SpriteAnimation.load(
      Assets.images.runningCharacter.path,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: .2,
        textureSize: Vector2.all(32),
      ),
      images: _images,
    );
    runningAnimation = SpriteAnimationComponent(
      animation: animation,
      size: size,
    );

    add(runningAnimation);

    final playerSpawn = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final spawn in playerSpawn.objects) {
      position = Vector2(spawn.x, spawn.y);
    }
  }

  void jump() => findBehavior<JumpingBehavior>().jump();
}
