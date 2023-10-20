import 'dart:async';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

typedef ImageObjectGroupComponentBuilder = Component Function({
  required TiledObject tiledObject,
  required Sprite sprite,
});

/// An object that given a tileset and object group, creates its components.
class ImageObjectGroupBuilder extends Component with HasGameRef<DashRunGame> {
  ImageObjectGroupBuilder({
    required this.leapMap,
    required this.tileLayerName,
    required this.tilesetPath,
    required this.firstGId,
    required this.componentBuilder,
  });

  final LeapMap leapMap;
  final String tileLayerName;
  final String tilesetPath;
  final int firstGId;
  final ImageObjectGroupComponentBuilder componentBuilder;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final itemsLayer = gameRef.leapMap.getTileLayer<ObjectGroup>(tileLayerName);
    final itemTiles = await gameRef.images.load(
      tilesetPath,
    );

    for (final object in itemsLayer.objects) {
      final spritesheet = SpriteSheet(
        image: itemTiles,
        srcSize: Vector2.all(gameRef.tileSize),
      );

      gameRef.leapMap.add(
        componentBuilder(
          tiledObject: object,
          sprite: spritesheet.getSpriteById(
            (object.gid ?? 0) - firstGId,
          ),
        ),
      );
    }
  }
}
