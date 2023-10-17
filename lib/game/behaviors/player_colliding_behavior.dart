import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class PlayerCollidingBehavior
    extends CollisionBehavior<PositionComponent, Player>
    with HasGameRef<DashRunGame> {
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (parent.collisionInfo.downCollision?.isHazard ?? false) {
      parent.health -= parent.collisionInfo.downCollision!.hazardDamage;
    }

    for (final other in parent.collisionInfo.otherCollisions ?? const []) {
      if (other is Item) {
        other.removeFromParent();
        parent.items.add(other);
      }

      if (other is Enemy) {
        parent.health -= other.enemyDamage;
      }

      if (parent.isDead) gameRef.gameOver();
    }
  }
}
