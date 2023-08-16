import 'package:dash_run/game/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class JumpingBehavior extends Behavior<Player> {
  final double jumpVelocity = -1200;

  void jump() {
    if (parent.yVelocity == 0) {
      parent.yVelocity = jumpVelocity;
    }
  }
}
