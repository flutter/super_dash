import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Enemies extends Component with HasGameRef<DashRunGame> {
  @override
  Future<void> onLoad() async {
    final tileset = game.leapMap.tiledMap.tileMap.map.tilesets.firstWhere(
      (tileset) => tileset.name == 'tile_items_v2',
    );
    final firstGId = tileset.firstGid ?? 0;
    final enemiesLayer = game.leapMap.getTileLayer<ObjectGroup>('enemies');
    final enemyTiles = await gameRef.images.load(
      'objects/tile_enemies_v2.png',
    );

    for (final object in enemiesLayer.objects) {
      final spritesheet = SpriteSheet(
        image: enemyTiles,
        srcSize: Vector2.all(gameRef.tileSize),
      );

      gameRef.leapMap.add(
        Enemy(
          tiledObject: object,
          sprite: spritesheet.getSpriteById(
            (object.gid ?? 0) - firstGId,
          ),
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
    this.enemyDamage = 1,
    super.static = true,
    super.collisionType = CollisionType.standard,
  });

  final int enemyDamage;
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
