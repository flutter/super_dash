import 'dart:async';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

enum ItemType {
  egg,
  wings,
  feather,
  goldenFeather;

  static ItemType fromGid(int gid) {
    return switch (gid) {
      740 => ItemType.egg,
      741 => ItemType.feather,
      742 => ItemType.goldenFeather,
      743 => ItemType.wings,
      _ => throw Exception('Invalid item gid: $gid'),
    };
  }

  int get points {
    return switch (this) {
      ItemType.egg => 1000,
      ItemType.feather => 10,
      ItemType.goldenFeather => 0,
      ItemType.wings => 0,
    };
  }
}

class Item extends PhysicalEntity<DashRunGame> {
  Item({
    required this.sprite,
    required this.tiledObject,
  })  : type = ItemType.fromGid(tiledObject.gid!),
        super(static: true, collisionType: CollisionType.standard);

  final ItemType type;
  late final Sprite sprite;
  late final TiledObject tiledObject;

  @override
  int get priority => 2;

  @override
  Future<void> onLoad() async {
    size = sprite.srcSize;
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
