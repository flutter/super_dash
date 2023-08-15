import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';

import 'package:flame/parallax.dart';

class Background extends ParallaxComponent<FixedResolutionFlameGame> {
  Background();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = gameRef.resolution.clone();
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('bg_day.png'),
        ParallaxImageData('bushes_fg.png'),
        ParallaxImageData('floor_fg.png'),
      ],
      fill: LayerFill.width,
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(5, 0),
      size: size,
    );
    isFullscreen = false;
  }
}
