import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class ObstacleScrollingBehavior extends Behavior<PositionedEntity>
    with HasGameRef<DashRunGame> {
  static const double scrollSpeed = 400;

  @override
  void update(double dt) {
    super.update(dt);

    parent.x = parent.x - scrollSpeed * dt;

    if (parent.x < -parent.size.x) {
      parent.removeFromParent();
      game.score++;
    }
  }
}
