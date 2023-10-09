import 'package:dash_run/game/dash_run_game.dart';
import 'package:dash_run/gen/assets.gen.dart';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Enemies extends Component with HasGameRef<DashRunGame> {
  @override
  Future<void> onLoad() async {
    final enemiesLayer = gameRef.leapMap.getTileLayer<ObjectGroup>('enemies');
    final enemyTiles = await gameRef.images.load(
      Assets.images.tileEnemiesV2.path,
    );

    for (final object in enemiesLayer.objects) {
      final spritesheet = SpriteSheet(
        image: enemyTiles,
        srcSize: Vector2.all(32),
      );

      gameRef.leapMap.add(
        Enemy(
          // We are sure we have a gid.
          sprite: spritesheet.getSpriteById(object.gid!),
          tiledObject: object,
        ),
      );
    }

    return super.onLoad();
  }
}

class Enemy extends PhysicalEntity<DashRunGame> {
  Enemy({
    required this.sprite,
    required this.tiledObject,
    super.static = true,
    super.collisionType = CollisionType.standard,
  });

  late final Sprite sprite;
  late final TiledObject tiledObject;

  @override
  Future<void> onLoad() async {
    size = sprite.srcSize;
    anchor = Anchor.center;
    position = Vector2(tiledObject.x, tiledObject.y);

    add(
      SpriteComponent(
        size: size,
        sprite: sprite,
      ),
    );

    return super.onLoad();
  }
}
