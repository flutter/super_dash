import 'dart:async';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

enum ItemType {
  acorn(10),
  egg(1000),
  goldenFeather(0);

  const ItemType(this.points);

  final int points;

  static ItemType fromGid(int gid, int initialGid) {
    if (gid == initialGid) {
      return ItemType.egg;
    } else if (gid == initialGid + 1) {
      return ItemType.acorn;
    } else if (gid == initialGid + 3) {
      return ItemType.goldenFeather;
    } else {
      return ItemType.egg;
    }
  }
}

class Item extends PhysicalEntity<DashRunGame> {
  Item({
    required this.tiledObject,
  }) : super(static: true, collisionType: CollisionType.standard);

  late final ItemType type;
  late final TiledObject tiledObject;

  @override
  int get priority => 2;

  @override
  Future<void> onLoad() async {
    type = ItemType.fromGid(
      tiledObject.gid ?? 0,
      gameRef.itemsTileset.firstGid ?? 0,
    );

    size = Vector2.all(gameRef.tileSize);
    position = Vector2(tiledObject.x, tiledObject.y);

    add(
      SpriteComponent(
        size: size,
        sprite: gameRef.itemsSpritesheet.getSpriteById(
          (tiledObject.gid ?? 0) - gameRef.itemsTileset.firstGid!,
        ),
        children: [
          SequenceEffect(
            [
              MoveEffect.by(
                -Vector2(0, gameRef.tileSize / 2),
                CurvedEffectController(.8, Curves.easeIn),
              ),
              MoveEffect.by(
                Vector2(0, gameRef.tileSize / 2),
                CurvedEffectController(.8, Curves.easeOut),
              ),
            ],
            infinite: true,
          ),
        ],
      ),
    );

    return super.onLoad();
  }
}
