import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class Item extends PhysicalEntity<FixedResolutionGame> {
  Item({
    required this.sprite,
    required this.tiledObject,
  }) : super(static: true, collisionType: CollisionType.standard) {
    size = sprite.srcSize;
    anchor = Anchor.center;
    position = Vector2(tiledObject.x, tiledObject.y);
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(20),
        anchor: Anchor.topLeft,
        position: size / 2,
      ),
    );
  }

  @override
  int get priority => 2;

  final Sprite sprite;
  final TiledObject tiledObject;

  static Future<void> addAllToMap(LeapMap map) async {
    final objectGroup = map.getTileLayer<ObjectGroup>('items');
    final tileset = await Flame.images.load(
      Assets.images.tileItemsV1.path.replaceAll('assets/images/', ''),
    );

    for (final object in objectGroup.objects) {
      map.add(
        Item(
          sprite: Sprite(tileset),
          tiledObject: object,
        ),
      );
    }
  }
}
