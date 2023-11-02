import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_dash/game/super_dash_game.dart';

typedef SpriteObjectGroupComponentBuilder = Component Function({
  required TiledObject tiledObject,
  required Sprite sprite,
});

/// A component that given a tileset and object group, creates its components.
class SpriteObjectGroupBuilder extends Component with HasGameRef<SuperDashGame> {
  SpriteObjectGroupBuilder({
    required this.tileLayerName,
    required this.tilesetPath,
    required this.tileset,
    required this.componentBuilder,
  });

  final String tileLayerName;
  final String tilesetPath;
  final Tileset tileset;
  final SpriteObjectGroupComponentBuilder componentBuilder;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final firstGid = tileset.firstGid ?? 0;
    final layer = gameRef.leapMap.getTileLayer<ObjectGroup>(tileLayerName);
    final tiles = await gameRef.images.load(
      tilesetPath,
    );

    for (final object in layer.objects) {
      final spritesheet = SpriteSheet(
        image: tiles,
        srcSize: Vector2.all(gameRef.tileSize),
      );

      gameRef.leapMap.add(
        componentBuilder(
          tiledObject: object,
          sprite: spritesheet.getSpriteById(
            (object.gid ?? 0) - firstGid,
          ),
        ),
      );
    }
  }
}
