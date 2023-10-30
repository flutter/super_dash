import 'dart:async';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

enum ItemType {
  acorn(10),
  egg(1000),
  goldenFeather(0);

  const ItemType(this.points);

  final int points;

  static ItemType fromGid(int gid) {
    return switch (gid) {
      752 => ItemType.egg,
      753 => ItemType.acorn,
      754 => ItemType.goldenFeather,
      _ => throw Exception('Invalid item gid: $gid'),
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
