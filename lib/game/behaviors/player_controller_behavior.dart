import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/widgets.dart';
import 'package:super_dash/game/game.dart';

class PlayerControllerBehavior extends Behavior<Player> {
  @visibleForTesting
  bool doubleJumpUsed = false;

  @override
  void update(double dt) {
    super.update(dt);

    if (parent.isPlayerTeleporting) return;

    // Reset the double jump.
    if (doubleJumpUsed && parent.isOnGround) {
      doubleJumpUsed = false;
    }

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
          if (parent.isOnGround) {
            parent.jumping = true;
          } else if (!parent.isOnGround &&
              (parent.doubleJumpEnabled && !doubleJumpUsed)) {
            parent.jumping = true;
            doubleJumpUsed = true;
          }
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
