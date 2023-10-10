import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';

class PlayerKeyboardControllerBehavior extends Behavior<Player> {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.space: (_) {
            return false;
          },
        },
        keyUp: {
          LogicalKeyboardKey.space: (_) {
            return false;
          },
        },
      ),
    );
  }
}
