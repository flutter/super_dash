import 'package:dash_run/game/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class FlyingBehavior extends Behavior<Player> {
  bool _enabled = false;

  bool get enabled => _enabled;

  bool _climbing = false;

  set enabled(bool value) {
    if (_enabled == value) {
      return;
    }
    _enabled = value;
    _climbing = value;

    if (value) {
      parent.runningAnimation.removeFromParent();
      parent.add(parent.flyingSprite);
    } else {
      parent.flyingSprite.removeFromParent();
      parent.add(parent.runningAnimation);
    }
  }

  void climb() {
    _climbing = true;
  }

  void glide() {
    _climbing = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_climbing) {
      parent.yVelocity = -400;
    }
  }
}
