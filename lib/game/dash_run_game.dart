import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

class DashRunGame extends LeapGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  DashRunGame({this.customBundle}) : super(tileSize: 64);

  static const prefix = 'assets/map/';
  static final _cameraViewport = Vector2(592, 1280);

  final AssetBundle? customBundle;

  late final SimpleCombinedInput input;
  late final SpriteObjectGroupBuilder items;
  late final ObjectGroupProximityBuilder enemies;

  int score = 0;

  Player? get player => world.firstChild<Player>();

  List<Tileset> get tilesets => leapMap.tiledMap.tileMap.map.tilesets;

  Tileset get itemsTileset {
    return tilesets.firstWhere(
      (tileset) => tileset.name == 'tile_items_v2',
    );
  }

  Tileset get enemiesTileset {
    return tilesets.firstWhere(
      (tileset) => tileset.name == 'tile_enemies_v2',
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera = CameraComponent.withFixedResolution(
      width: _cameraViewport.x,
      height: _cameraViewport.y,
    )..world = world;

    images = Images(
      prefix: prefix,
      bundle: customBundle,
    );

    await loadWorldAndMap(
      images: images,
      prefix: prefix,
      bundle: customBundle,
      tiledMapPath: 'flutter_runnergame_map_v05b.tmx',
    );

    input = SimpleCombinedInput(
      keyboardInput: SimpleKeyboardInput(
        rightKeys: {
          PhysicalKeyboardKey.space,
        },
      ),
    );

    final player = Player(
      levelSize: leapMap.tiledMap.size.clone(),
      cameraViewport: _cameraViewport,
    );
    world.add(player);

    items = SpriteObjectGroupBuilder(
      tilesetPath: 'objects/tile_items_v2.png',
      tileLayerName: 'items',
      tileset: itemsTileset,
      componentBuilder: Item.new,
    );

    enemies = ObjectGroupProximityBuilder<Player>(
      proximity: _cameraViewport.x * 1.5,
      tilesetPath: 'objects/tile_enemies_v2.png',
      tileLayerName: 'enemies',
      tileset: enemiesTileset,
      componentBuilder: Enemy.new,
    );

    await addAll([
      input,
      items,
      enemies,
      ScoreLabel(
        initialScore: score,
        initialItems: player.powerUps.length,
        initialHealth: player.health,
      ),
    ]);
  }

  void gameOver() {
    score = 0;
    world.firstChild<Player>()?.removeFromParent();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () => world.add(
        Player(
          levelSize: leapMap.tiledMap.size.clone(),
          cameraViewport: _cameraViewport,
        ),
      ),
    );
  }

  void addCameraDebugger() {
    if (descendants().whereType<CameraDebugger>().isEmpty) {
      final player = world.firstChild<Player>()!;

      final cameraDebugger = CameraDebugger(
        position: player.position.clone(),
      );
      world.add(cameraDebugger);

      final anchor = PlayerCameraAnchor(
        levelSize: leapMap.tiledMap.size.clone(),
        cameraViewport: _cameraViewport,
      );
      cameraDebugger.add(anchor);
      camera.follow(anchor);

      player.removeFromParent();
    }
  }
}
