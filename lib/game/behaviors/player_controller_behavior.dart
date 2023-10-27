import 'package:dash_run/game/game.dart';

import 'package:flame_behaviors/flame_behaviors.dart';

class PlayerControllerBehavior extends Behavior<Player> {
  @override
  void update(double dt) {
    super.update(dt);

    if (parent.isAlive) {
      // Keep jumping if started.
      if (parent.jumping && parent.input.isPressed && parent.isOnGround) {
        parent.jumping = true;
      } else {
        parent.jumping = false;
      }
    }

    if (!parent.input.justPressed) return;

    if (parent.input.isPressedRight) {
      // Tapped right.
      if (parent.walking) {
        if (!parent.faceLeft) {
          // Already moving right.
          if (parent.isOnGround) parent.jumping = true;
        } else {
          // Moving left, stop.
          parent
            ..walking = false
            ..faceLeft = false;
        }
      } else {
        // Standing still.
        parent
          ..walking = true
          ..faceLeft = false;
      }
    }
  }
}
