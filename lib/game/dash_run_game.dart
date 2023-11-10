import 'dart:async';

import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/score/score.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

bool _tsxPackingFilter(Tileset tileset) {
  return !(tileset.source ?? '').startsWith('anim');
}

class DashRunGame extends LeapGame
    with TapDetector, HasKeyboardHandlerComponents {
  DashRunGame({
    required this.gameBloc,
    required this.audioController,
    this.customBundle,
    this.inMapTester = false,
  }) : super(
          tileSize: 64,
          configuration: const LeapConfiguration(
            tiled: TiledOptions(
              atlasMaxX: 4048,
              atlasMaxY: 4048,
              tsxPackingFilter: _tsxPackingFilter,
            ),
          ),
        );

  static final _cameraViewport = Vector2(592, 1024);
  static const prefix = 'assets/map/';
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

  final GameBloc gameBloc;
  final AssetBundle? customBundle;
  final AudioController audioController;
  final List<VoidCallback> _inputListener = [];

  late final SimpleCombinedInput input;
  late final SpriteSheet itemsSpritesheet;
  final bool inMapTester;

  GameState get state => gameBloc.state;

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

  void addInputListener(VoidCallback listener) {
    _inputListener.add(listener);
  }

  void removeInputListener(VoidCallback listener) {
    _inputListener.remove(listener);
  }

  void _triggerInputListeners() {
    for (final listener in _inputListener) {
      listener();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    _triggerInputListeners();
    overlays.remove('tapToJump');
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (inMapTester) {
      _addMapTesterFeatures();
    }

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

    itemsSpritesheet = SpriteSheet(
      image: await images.load('objects/tile_items_v2.png'),
      srcSize: Vector2.all(tileSize),
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

    await _addSpawners();
    _addTreeHouseFrontLayer();
    _addTreeHouseSign();

    add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.space: (_) {
            _triggerInputListeners();
            overlays.remove('tapToJump');
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

  void _addTreeHouseSign() {
    world.add(
      TreeSign(
        position: Vector2(
          448,
          1862,
        ),
      ),
    );
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
    // Removed since the result didn't ended up good.
    // Leaving in comment if we decide to bring it back.
    // audioController.stopBackgroundSfx();

    world.firstChild<Player>()?.removeFromParent();

    _resetEntities();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () async {
        await loadWorldAndMap(
          images: images,
          prefix: prefix,
          bundle: customBundle,
          tiledMapPath: _sections.first,
        );
        if (isLastSection || isFirstSection) {
          _addTreeHouseFrontLayer();
        }

        if (isFirstSection) {
          _addTreeHouseSign();
        }
        final newPlayer = Player(
          levelSize: leapMap.tiledMap.size.clone(),
          cameraViewport: _cameraViewport,
        );
        await world.add(newPlayer);

        await newPlayer.mounted;
        await _addSpawners();
        overlays.add('tapToJump');
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
    world.firstChild<ObjectGroupProximityBuilder<Player>>()?.removeFromParent();
    world.firstChild<TreeHouseFront>()?.removeFromParent();
    world.firstChild<TreeSign>()?.removeFromParent();

    leapMap.children
        .whereType<Enemy>()
        .forEach((enemy) => enemy.removeFromParent());
    leapMap.children
        .whereType<Item>()
        .forEach((enemy) => enemy.removeFromParent());
  }

  Future<void> _addSpawners() async {
    await addAll([
      ObjectGroupProximityBuilder<Player>(
        proximity: _cameraViewport.x * 1.5,
        tileLayerName: 'items',
        tileset: itemsTileset,
        componentBuilder: Item.new,
      ),
      ObjectGroupProximityBuilder<Player>(
        proximity: _cameraViewport.x * 1.5,
        tileLayerName: 'enemies',
        tileset: enemiesTileset,
        componentBuilder: Enemy.new,
      ),
    ]);
  }

  Future<void> _loadNewSection() async {
    final nextSectionIndex = state.currentSection + 1 < _sections.length
        ? state.currentSection + 1
        : 0;

    final nextSection = _sections[nextSectionIndex];

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
    player?.spritePaintColor(Colors.white);
    player?.isPlayerTeleporting = false;

    _setSectionBackground();
  }

  void sectionCleared() {
    if (isLastSection) {
      player?.spritePaintColor(Colors.transparent);
      player?.walking = false;
    }

    _loadNewSection();

    gameBloc
      ..add(GameScoreIncreased(by: 1000 * state.currentLevel))
      ..add(GameSectionCompleted(sectionCount: _sections.length));
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
    player?.x = leapMap.tiledMap.size.x - (player?.size.x ?? 0) * 10 * 4;
    if (state.currentSection == 2) {
      player?.y = (player?.y ?? 0) - (tileSize * 4);
    }
  }

  void showHitBoxes() {
    descendants()
        .whereType<PhysicalEntity>()
        .where(
          (element) => element is Player || element is Item || element is Enemy,
        )
        .forEach((entity) => entity.debugMode = true);
  }

  void _addMapTesterFeatures() {
    add(FpsComponent());
    add(
      FpsTextComponent(
        position: Vector2(0, 0),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
