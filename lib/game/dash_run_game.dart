import 'dart:async';

import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/score/score.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

class DashRunGame extends LeapGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  DashRunGame({
    required this.gameBloc,
    required this.audioController,
    this.customBundle,
  }) : super(
          tileSize: 64,
          configuration: const LeapConfiguration(
            tiled: TiledOptions(
              atlasMaxX: 4048,
              atlasMaxY: 4048,
            ),
          ),
        );

  static const prefix = 'assets/map/';
  static final _cameraViewport = Vector2(592, 1024);

  final GameBloc gameBloc;
  final AssetBundle? customBundle;
  final AudioController audioController;

  late final SimpleCombinedInput input;

  GameState get state => gameBloc.state;

  static const _sections = [
    'flutter_runnergame_map_A.tmx',
    'flutter_runnergame_map_B.tmx',
    'flutter_runnergame_map_C.tmx',
  ];

  static const _sectionsBackgroundColor = [
    Color(0xffe9e9df),
    Color(0xffdae2ee),
    Color(0xff0353b0),
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

    if (kIsWeb && audioController.isMusicEnabled) {
      audioController.startMusic();
    }

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
    _setSectionBackground();

    final player = Player(
      levelSize: leapMap.tiledMap.size.clone(),
      cameraViewport: _cameraViewport,
    );
    unawaited(
      world.addAll([player]),
    );

    input = SimpleCombinedInput(
      keyboardInput: SimpleKeyboardInput(
        rightKeys: {
          PhysicalKeyboardKey.space,
        },
      ),
    );
    await add(input);

    await _addSpawners();
    _addTreeHouseFrontLayer();
  }

  void _addTreeHouseFrontLayer() {
    final layer = leapMap.tiledMap.tileMap.renderableLayers.last;
    world.add(TreeHouseFront(renderFront: layer.render));
  }

  void _setSectionBackground() {
    camera.backdrop = RectangleComponent(
      size: size.clone(),
      paint: Paint()..color = _sectionsBackgroundColor[state.currentSection],
    );
  }

  void gameOver() {
    gameBloc.add(const GameOver());
    audioController.stopBackgroundSfx();

    world.firstChild<Player>()?.removeFromParent();

    _resetEntities();

    if (isLastSection || isFirstSection) {
      _addTreeHouseFrontLayer();
    }

    Future<void>.delayed(
      const Duration(seconds: 1),
      () async {
        final newPlayer = Player(
          levelSize: leapMap.tiledMap.size.clone(),
          cameraViewport: _cameraViewport,
        );
        await world.add(newPlayer);

        await newPlayer.mounted;
        await _addSpawners();
      },
    );

    if (buildContext != null) {
      final score = gameBloc.state.score;
      Navigator.of(buildContext!).push(
        ScorePage.route(score: score),
      );
    }
  }

  void _resetEntities() {
    world.firstChild<SpriteObjectGroupBuilder>()?.removeFromParent();
    world.firstChild<ObjectGroupProximityBuilder<Player>>()?.removeFromParent();
    world.firstChild<TreeHouseFront>()?.removeFromParent();

    leapMap.children
        .whereType<Enemy>()
        .forEach((enemy) => enemy.removeFromParent());
  }

  Future<void> _addSpawners() async {
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
    _setSectionBackground();
    final nextSection = _sections[state.currentSection];

    _resetEntities();

    await loadWorldAndMap(
      images: images,
      prefix: prefix,
      bundle: customBundle,
      tiledMapPath: nextSection,
    );

    await _addSpawners();

    if (isLastSection || isFirstSection) {
      _addTreeHouseFrontLayer();
    }
  }

  @override
  void onMapUnload() {
    player?.velocity.setZero();
  }

  @override
  void onMapLoaded() {
    player?.loadSpawnPoint();
    player?.walking = true;
    player?.animations.paint.color = Colors.white;
    player?.isPlayerTeleporting = false;
  }

  void sectionCleared() {
    gameBloc
      ..add(GameScoreIncreased(by: 1000 * state.currentLevel))
      ..add(GameSectionCompleted(sectionCount: _sections.length));

    _loadNewSection();
  }

  bool get isLastSection => state.currentSection == _sections.length - 1;
  bool get isFirstSection => state.currentSection == 0;

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
