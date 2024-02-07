import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

bool _tsxPackingFilter(Tileset tileset) {
  return !(tileset.source ?? '').startsWith('anim');
}

Paint _layerPaintFactory(double opacity) {
  return Paint()
    ..color = Color.fromRGBO(255, 255, 255, opacity)
    ..isAntiAlias = false;
}

class SuperDashGame extends LeapGame
    with TapDetector, HasKeyboardHandlerComponents {
  SuperDashGame({
    required this.gameBloc,
    required this.audioController,
    this.customBundle,
    this.inMapTester = false,
  }) : super(
          tileSize: 64,
          configuration: const LeapConfiguration(
            tiled: TiledOptions(
              tsxPackingFilter: _tsxPackingFilter,
              layerPaintFactory: _layerPaintFactory,
            ),
          ),
        );

  static const prefix = 'assets/map/';
  static const _sections = [
    'background_2.tmx',
  ];

  final GameBloc gameBloc;
  final AssetBundle? customBundle;
  final AudioController audioController;
  final List<VoidCallback> _inputListener = [];

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
      //audioController.startMusic();
    }

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

    leapMap.position = Vector2(-leapMap.width / 2, -200);

    camera = CameraComponent.withFixedResolution(
      world: world,
      width: tileSize * 10,
      height: tileSize * 6,
    );

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

  void _setSectionBackground() {
/*    final colors = _sectionsBackgroundColor[state.currentSection];
    camera.backdrop = RectangleComponent(
      size: size.clone(),
      paint: Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.x, size.y),
          [
            colors.$1,
            colors.$2,
          ],
        ),
    );*/
  }

  void _resetEntities() {
    world.firstChild<TreeHouseFront>()?.removeFromParent();
    world.firstChild<TreeSign>()?.removeFromParent();

    leapMap.children
        .whereType<Enemy>()
        .forEach((enemy) => enemy.removeFromParent());
    leapMap.children
        .whereType<Item>()
        .forEach((enemy) => enemy.removeFromParent());
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
  }

  @override
  void onMapUnload(LeapMap map) {
    player?.velocity.setZero();
  }

  @override
  void onMapLoaded(LeapMap map) {
    player?.loadSpawnPoint();
    player?.loadRespawnPoints();
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
    void show() {
      descendants()
          .whereType<PhysicalEntity>()
          .where(
            (element) =>
                element is Player || element is Item || element is Enemy,
          )
          .forEach((entity) => entity.debugMode = true);
    }

    show();
    add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: show,
      ),
    );
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
