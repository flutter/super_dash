import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';
import 'package:super_dash/game/super_dash_game.dart';

enum ItemType {
  acorn(10),
  egg(1000),
  goldenFeather(0);

  const ItemType(this.points);

  final int points;

  static ItemType fromType(String? type) {
    if (type == 'Egg') {
      return ItemType.egg;
    } else if (type == 'Feather') {
      return ItemType.goldenFeather;
    }
    return ItemType.acorn;
  }
}

class Item extends PhysicalEntity<SuperDashGame> {
  Item({
    required this.tiledObject,
  }) : super(static: true, collisionType: CollisionType.standard);

  late final ItemType type;
  late final TiledObject tiledObject;

  @override
  int get priority => 2;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    type = ItemType.fromType(
      (tiledObject.properties.byName['Type'] as StringProperty?)?.value,
    );

    size = Vector2.all(gameRef.tileSize);
    position = Vector2(tiledObject.x, tiledObject.y);

    if (type == ItemType.egg) {
      final eggAnimation = await gameRef.loadSpriteAnimation(
        'anim/spritesheet_item_egg.png',
        SpriteAnimationData.sequenced(
          amount: 48,
          amountPerRow: 8,
          textureSize: Vector2.all(gameRef.tileSize),
          stepTime: .042,
        ),
      );
      add(
        SpriteAnimationComponent(
          animation: eggAnimation,
          size: size,
        ),
      );
    } else if (type == ItemType.goldenFeather) {
      final featherAnimation = await gameRef.loadSpriteAnimation(
        'anim/spritesheet_item_feather.png',
        SpriteAnimationData.sequenced(
          amount: 30,
          amountPerRow: 6,
          textureSize: Vector2.all(gameRef.tileSize),
          stepTime: .042,
        ),
      );
      add(
        SpriteAnimationComponent(
          animation: featherAnimation,
          size: size,
        ),
      );
    } else {
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
    }
  }
}
