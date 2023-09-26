import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GravityBehavior extends Behavior<Player> with HasGameRef<DashRunGame> {
  final double gravity = 2000;

  @override
  void update(double dt) {
    super.update(dt);

    parent
      ..yVelocity = parent.yVelocity + gravity * dt
      ..y = parent.y + parent.yVelocity * dt;

    final boundary = gameRef.resolution.y - DashRunGame.floorSize;
    if (parent.y > boundary) {
      parent
        ..y = boundary
        ..yVelocity = 0;

      parent.findBehavior<FlyingBehavior>().enabled = false;
    }
  }
}
