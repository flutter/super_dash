import 'dart:async';

import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

class DashRunGame extends LeapGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  DashRunGame({
    required this.audioController,
    this.customBundle,
  }) : super(
          tileSize: 64,
          configuration: const LeapConfiguration(
            tiled: TiledOptions(
              atlasMaxX: 8192,
              atlasMaxY: 8192,
            ),
          ),
        );

  static const prefix = 'assets/map/';
  static final _cameraViewport = Vector2(592, 1024);

  final AssetBundle? customBundle;

  late final SimpleCombinedInput input;
  final AudioController audioController;

  int score = 0;
  int currentLevel = 1;
  int currentSection = 0;

  static const _sections = [
    'flutter_runnergame_map_A.tmx',
    'flutter_runnergame_map_B.tmx',
    'flutter_runnergame_map_C.tmx',
  ];

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
      tiledMapPath: _sections.first,
    );

    final player = Player(
      levelSize: leapMap.tiledMap.size.clone(),
      cameraViewport: _cameraViewport,
    );
    unawaited(
      world.addAll(
        [
          player,
        ],
      ),
    );

    input = SimpleCombinedInput(
      keyboardInput: SimpleKeyboardInput(
        rightKeys: {
          PhysicalKeyboardKey.space,
        },
      ),
    );

    await _addSpawnmers();

    await addAll([
      input,
      ScoreLabel(
        initialScore: score,
        initialItems: player.powerUps.length,
        initialHealth: player.health,
      ),
    ]);
  }

  void gameOver() {
    score = 0;
    currentLevel = 1;
    world.firstChild<Player>()?.removeFromParent();

    _resetEntities();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () async {
        final newPlayer = Player(
          levelSize: leapMap.tiledMap.size.clone(),
          cameraViewport: _cameraViewport,
        );
        await world.add(newPlayer);

        await newPlayer.mounted;
        await _addSpawnmers();
      },
    );
  }

  void _resetEntities() {
    world.firstChild<SpriteObjectGroupBuilder>()?.removeFromParent();
    world.firstChild<ObjectGroupProximityBuilder<Player>>()?.removeFromParent();

    leapMap.children
        .whereType<Enemy>()
        .forEach((enemy) => enemy.removeFromParent());
  }

  Future<void> _addSpawnmers() async {
    await addAll([
      SpriteObjectGroupBuilder(
        tilesetPath: 'objects/tile_items_v2.png',
        tileLayerName: 'items',
        tileset: itemsTileset,
        componentBuilder: Item.new,
      ),
      ObjectGroupProximityBuilder<Player>(
        proximity: _cameraViewport.x * 1.5,
        tilesetPath: 'objects/tile_enemies_v2.png',
        tileLayerName: 'enemies',
        tileset: enemiesTileset,
        componentBuilder: Enemy.new,
      ),
    ]);
  }

  Future<void> _loadNewSection() async {
    final nextSection = _sections[currentSection];

    _resetEntities();

    await loadWorldAndMap(
      images: images,
      prefix: prefix,
      bundle: customBundle,
      tiledMapPath: nextSection,
    );

    await _addSpawnmers();
  }

  void sectionCleared() {
    score += 1000 * currentLevel;

    if (currentSection < _sections.length - 1) {
      currentSection++;
    } else {
      currentSection = 0;
      currentLevel++;
    }

    _loadNewSection();
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

      final proximityBuilders =
          descendants().whereType<ObjectGroupProximityBuilder<Player>>();
      for (final proximityBuilder in proximityBuilders) {
        proximityBuilder.currentReference = cameraDebugger;
      }

      player.removeFromParent();
    }
  }

  void toggleInvincibility() {
    player?.isPlayerInvincible = !(player?.isPlayerInvincible ?? false);
  }

  void teleportPlayerToEnd() {
    player?.x = leapMap.tiledMap.size.x - (player?.size.x ?? 0) * 40;
  }

  void showHitBoxes() {
    descendants()
        .whereType<PhysicalEntity>()
        .where(
          (element) => element is Player || element is Item || element is Enemy,
        )
        .forEach((entity) => entity.debugMode = true);
  }
}
