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
    if (other is Enemies) {
      gameRef.gameOver();
    }
  }
}
