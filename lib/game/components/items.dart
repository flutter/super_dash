import 'dart:async';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Items extends Component with HasGameRef<DashRunGame> {
  @override
  Future<void> onLoad() async {
    final itemsLayer = gameRef.leapMap.getTileLayer<ObjectGroup>('items');
    final itemTiles = await gameRef.images.load(
      'objects/tile_items_v2.png',
    );

    for (final object in itemsLayer.objects) {
      final spritesheet = SpriteSheet(
        image: itemTiles,
        srcSize: Vector2.all(32),
      );

      gameRef.leapMap.add(
        Item(
          // We are sure we have a gid.
          sprite: spritesheet.getSpriteById(object.gid!),
          tiledObject: object,
        ),
      );
    }

    return super.onLoad();
  }
}

class Item extends PhysicalEntity<DashRunGame> {
  Item({
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
