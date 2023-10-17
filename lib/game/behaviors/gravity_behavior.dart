import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class GravityBehavior extends Behavior<Player> with HasGameRef<DashRunGame> {
  GravityBehavior({required this.gravity});

  final double gravity;

  @override
  void update(double dt) {
    super.update(dt);

    parent
      ..velocity.y = parent.velocity.y + gravity * dt
      ..y = parent.y + parent.velocity.y * dt;

    if (parent.isOnGround) {
      parent.velocity.y = 0;
    }
  }
}
