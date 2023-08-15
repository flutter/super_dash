import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';

class PlayerKeyboardControllerBehavior extends Behavior<Player> {
  static const _flyHoldLimit = 0.5;

  double _flyHoldTimer = 0;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.space: (_) {
            
            final flying = parent.findBehavior<FlyingBehavior>();
            if (flying.enabled) {
              flying.climb();
            } else if (_flyHoldTimer <= 0) {
              _flyHoldTimer = _flyHoldLimit;
            }

            return false;
          },
        },
        keyUp: {
          LogicalKeyboardKey.space: (_) {
            final flying = parent.findBehavior<FlyingBehavior>();
            if (flying.enabled) {
              flying.glide();
            } else {
              _flyHoldTimer = 0;
              parent.findBehavior<JumpingBehavior>().jump();
            }
            return false;
          },
        },
      ),
    );
  }

  @override
    void update(double dt) {
      super.update(dt);

      if (_flyHoldTimer > 0) {
        _flyHoldTimer -= dt;
        if (_flyHoldTimer <= 0) {
          parent.findBehavior<FlyingBehavior>().enabled = true;
        }
      }
    }
}
