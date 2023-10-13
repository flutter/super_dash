import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:flame/components.dart';

import 'package:flame/parallax.dart';

class Background extends ParallaxComponent<DashRunGame>
    with HasGameRef<DashRunGame> {
  Background();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = gameRef.size.clone();
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData(Assets.map.tiles.tilePlainsHillsV01Png.path),
        ParallaxImageData(Assets.map.tiles.tileMountainMountainsV01Png.path),
      ],
      fill: LayerFill.width,
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(5, 0),
      size: size,
    );
    isFullscreen = false;
  }
}
