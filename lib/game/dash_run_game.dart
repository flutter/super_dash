import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

class DashRunGame extends LeapGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  DashRunGame({this.customBundle}) : super(tileSize: 64);

  static const prefix = 'assets/map/';
  static final _cameraViewport = Vector2(592, 1280);

  final AssetBundle? customBundle;

  late final Player player;
  late final SimpleCombinedInput input;

  int score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera = CameraComponent.withFixedResolution(
      width: _cameraViewport.x,
      height: _cameraViewport.y,
    );

    images = Images(
      prefix: prefix,
      bundle: customBundle,
    );

    await loadWorldAndMap(
      camera: camera,
      images: images,
      prefix: prefix,
      bundle: customBundle,
      tiledMapPath: 'flutter_runnergame_map_v05.tmx',
    );

    input = SimpleCombinedInput();

    player = Player(
      levelSize: leapMap.tiledMap.size.clone(),
      cameraViewport: _cameraViewport,
    );
    world.add(player);

    final tilesets = leapMap.tiledMap.tileMap.map.tilesets;

    final itemsTileset = tilesets.firstWhere(
      (tileset) => tileset.name == 'tile_items_v2',
    );

    final enemiesTileset = tilesets.firstWhere(
      (tileset) => tileset.name == 'tile_enemies_v2',
    );

    final items = SpriteObjectGroupBuilder(
      tileset: itemsTileset,
      tileLayerName: 'items',
      tilesetPath: 'objects/tile_items_v2.png',
      componentBuilder: Item.new,
    );

    final enemies = ObjectGroupProximityBuilder(
      proximity: _cameraViewport.x * 1.5,
      tilesetPath: 'objects/tile_enemies_v2.png',
      tileLayerName: 'enemies',
      tileset: enemiesTileset,
      reference: player,
      componentBuilder: Enemy.new,
    );

    await addAll([items, enemies, input, ScoreLabel()]);
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
