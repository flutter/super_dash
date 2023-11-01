import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';
import 'package:pathxp/pathxp.dart';

class Enemy extends PhysicalEntity<DashRunGame> {
  Enemy({
    required this.sprite,
    required this.tiledObject,
    this.enemyDamage = 1,
  }) : super(collisionType: CollisionType.standard);

  final int enemyDamage;
  late final Sprite sprite;
  late final TiledObject tiledObject;

  @override
  int get priority => 1;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(gameRef.tileSize * .5);
    position = Vector2(tiledObject.x, tiledObject.y);

    final path =
        (tiledObject.properties.byName['Path'] as StringProperty?)?.value;

    if (path != null) {
      final pathXp = Pathxp(path);
      add(FollowPathBehavior(pathXp));
    }

    add(
      SpriteComponent(
        size: Vector2.all(gameRef.tileSize),
        sprite: sprite,
        anchor: Anchor.center,
        position: size / 2 - Vector2(0, size.y / 2),
      ),
    );

    return super.onLoad();
  }
}
