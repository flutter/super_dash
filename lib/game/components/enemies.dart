import 'package:dash_run/game/dash_run_game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Enemies extends PositionComponent with HasGameRef<DashRunGame> {
  static const _width = 130.0;
  static const _height = 25.0;
  static final _images = Images(prefix: '');

  @override
  double get width => _width;

  @override
  double get height => _height;

  Future<void> addAllToMap(LeapMap map) async {
    final enemies = await Sprite.load(
      Assets.images.tileEnemiesV1.path,
      images: _images,
    );
    final enemiesLayer = map.getTileLayer<TileLayer>('Enemies');
    final enemyTiles = _EnemyTile.generate(
      map: map.tiledMap.tileMap.map,
      layer: enemiesLayer,
      sprite: enemies,
    );
    for (final enemyTile in enemyTiles) {
      for (final column in enemyTile) {
        if (column != null) {
          map.add(column);
        }
      }
    }
  }
}

class _EnemyTile extends PhysicalEntity {
  _EnemyTile(
    this.gridX,
    this.gridY, {
    required this.tile,
    required this.spriteComponent,
  }) : super(static: true, collisionType: CollisionType.standard);

  final Tile tile;
  final SpriteComponent spriteComponent;
  final int gridX;
  final int gridY;

  static List<List<_EnemyTile?>> generate({
    required TiledMap map,
    required TileLayer layer,
    required Sprite sprite,
  }) {
    final enemyTiles = List.generate(
      layer.width,
      (_) => List<_EnemyTile?>.filled(layer.height, null),
    );

    for (var x = 0; x < layer.width; x++) {
      for (var y = 0; y < layer.height; y++) {
        final gid = layer.tileData![y][x].tile;
        if (gid == 0) {
          continue;
        }
        final tile = map.tileByGid(gid)!;
        enemyTiles[x][y] = _EnemyTile(
          x,
          y,
          tile: tile,
          spriteComponent: SpriteComponent(sprite: sprite),
        );
      }
    }
    return enemyTiles;
  }
}
