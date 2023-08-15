import 'dart:async';
import 'dart:math';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';

class Obstacles extends TimerComponent
    with HasGameRef<FixedResolutionFlameGame> {
  Obstacles({
    Random? random,
  }) : super(
          period: 1,
          repeat: true,
        ) {
    _rng = random ?? Random();
  }

  late final Random _rng;

  @override
    FutureOr<void> onLoad() async {
      await super.onLoad();

      onTick();
    }

  @override
  void onTick() {
    // Adds an obstacle if chance allows it (1 in 3)
    if (_rng.nextInt(3) == 0) {
      final possibleArea = Vector2(
        gameRef.resolution.x,
        gameRef.resolution.y - DashRunGame.floorSize,
      );

      gameRef.world.add(
        Obstacle(
          position: Vector2(
            possibleArea.x,
            possibleArea.y * _rng.nextDouble(),
          ),
        ),
      );
    }
  }
}
