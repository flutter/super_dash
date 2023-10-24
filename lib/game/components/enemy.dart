import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

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
