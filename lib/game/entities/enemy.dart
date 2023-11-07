import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';
import 'package:pathxp/pathxp.dart';

class Enemy extends PhysicalEntity<DashRunGame> {
  Enemy({
    required this.tiledObject,
    required this.firstGid,
    this.enemyDamage = 1,
  }) : super(
          collisionType: CollisionType.standard,
          static: tiledObject.properties.byName['Fly']?.value as bool? ?? false,
        );

  final int enemyDamage;
  final int firstGid;
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

          final spritePosition = size / 2 - Vector2(0, size.y / 2);

    print('${tiledObject.gid} - ${firstGid}');
    if (tiledObject.gid == firstGid) {
      // Bettle
      final bettleAnimation = await gameRef.loadSpriteAnimation(
        'anim/spritesheet_enemy_bettle.png',
        SpriteAnimationData.sequenced(
          amount: 16,
          amountPerRow: 8,
          textureSize: Vector2.all(64),
          stepTime: .04,
        ),
      );

      add(
        SpriteAnimationComponent(
          size: Vector2.all(gameRef.tileSize),
          animation: bettleAnimation,
          anchor: Anchor.center,
          position: spritePosition,
        ),
      );
    } else if (tiledObject.gid == firstGid + 1) {
      // Butterfly
    } else if (tiledObject.gid == firstGid + 2) {
      // Grasshopper
    } else if (tiledObject.gid == firstGid + 3) {
      // Bee
    } else if (tiledObject.gid == firstGid + 4) {
      // Ant
    } else if (tiledObject.gid == firstGid + 5) {
      // Firefly
    }

    return super.onLoad();
  }

  void _spriteFallback() {}
}
