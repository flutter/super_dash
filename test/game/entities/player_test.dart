import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

class _MockImage extends Mock implements Image {}

class _MockImages extends Mock implements Images {}

class _MockGameBloc extends MockBloc<GameEvent, GameState>
    implements GameBloc {}

class _MockAudioController extends Mock implements AudioController {}

class _MockLeapMap extends Mock implements LeapMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _MockTiledComponent extends Mock implements TiledComponent {}

class _MockRenderableTiledMap extends Mock implements RenderableTiledMap {}

class _MockTileset extends Mock implements Tileset {}

class _TestSuperDashGame extends SuperDashGame {
  _TestSuperDashGame({
    required super.gameBloc,
    required super.audioController,
    this.spawnObects = const [],
    this.respawnObects = const [],
  });

  final List<TiledObject> spawnObects;
  final List<TiledObject> respawnObects;

  @override
  Future<void> onLoad() async {
    // Noop
  }

  @override
  Future<void> loadWorldAndMap({
    required String tiledMapPath,
    String prefix = 'assets/tiles/',
    AssetBundle? bundle,
    Images? images,
    Map<String, TiledObjectHandler> tiledObjectHandlers = const {},
    LeapMapTransition? transitionComponent,
  }) async {
    // noop
  }

  @override
  Images get images {
    final instance = _MockImages();

    final imageInstance = _MockImage();
    when(() => imageInstance.width).thenReturn(100);
    when(() => imageInstance.height).thenReturn(100);
    when(() => instance.load(any())).thenAnswer((_) async => imageInstance);

    return instance;
  }

  LeapMap? _leapMap;

  @override
  LeapMap get leapMap {
    if (_leapMap == null) {
      final map = _MockLeapMap();

      when(() => map.children).thenReturn(ComponentSet());

      when(() => map.width).thenReturn(100);
      when(() => map.height).thenReturn(100);

      final spawnGroup = _MockObjectGroup();
      when(() => spawnGroup.objects).thenReturn(spawnObects);

      final respawnGroup = _MockObjectGroup();
      when(() => respawnGroup.objects).thenReturn(respawnObects);

      when(() => map.getTileLayer<ObjectGroup>('spawn')).thenReturn(spawnGroup);
      when(() => map.getTileLayer<ObjectGroup>('respawn'))
          .thenReturn(respawnGroup);

      final tiledComponent = _MockTiledComponent();

      final tiledMap = _MockRenderableTiledMap();
      when(() => tiledComponent.tileMap).thenReturn(tiledMap);
      when(() => tiledMap.renderableLayers).thenReturn([]);

      final itemTileset = _MockTileset();
      when(() => itemTileset.name).thenReturn('tile_items_v2');

      final enemyTileset = _MockTileset();
      when(() => enemyTileset.name).thenReturn('tile_enemies_v2');

      when(() => tiledMap.map).thenReturn(
        TiledMap(
          width: 640,
          height: 640,
          tileWidth: 64,
          tileHeight: 64,
          tilesets: [
            itemTileset,
            enemyTileset,
          ],
        ),
      );

      when(() => map.tiledMap).thenReturn(tiledComponent);
      _leapMap = map;

      when(() => map.getTileLayer<ObjectGroup>('items')).thenReturn(
        ObjectGroup(
          name: '',
          objects: const [],
        ),
      );

      when(() => map.getTileLayer<ObjectGroup>('enemies')).thenReturn(
        ObjectGroup(
          name: '',
          objects: const [],
        ),
      );
    }

    return _leapMap!;
  }
}

void main() {
  group('Player', () {
    late GameBloc gameBloc;
    late AudioController audioController;

    setUp(() {
      gameBloc = _MockGameBloc();
      audioController = _MockAudioController();

      when(() => gameBloc.state).thenReturn(const GameState.initial());
    });

    _TestSuperDashGame createGame() {
      return _TestSuperDashGame(
        gameBloc: gameBloc,
        audioController: audioController,
        spawnObects: [
          TiledObject(id: 1, x: 10, y: 10),
        ],
        respawnObects: [
          TiledObject(id: 2, x: 100, y: 100),
          TiledObject(id: 3, x: 200, y: 200),
        ],
      );
    }

    testWithGame(
      'correctly loads',
      createGame,
      (game) async {
        await game.ensureAdd(
          Player(
            levelSize: Vector2.all(200),
            cameraViewport: Vector2.all(200),
          ),
        );

        final player = game.firstChild<Player>();
        expect(player, isNotNull);

        expect(player?.spawn, equals(Vector2.all(10)));
        expect(
          player?.respawnPoints,
          equals([Vector2.all(100), Vector2.all(200)]),
        );
      },
    );

    testWithGame(
      'sets the player to teleport when reach the edge of the level',
      createGame,
      (game) async {
        final player = Player(
          levelSize: Vector2.all(200),
          cameraViewport: Vector2.all(200),
        );
        await game.ensureAdd(player);

        expect(player.isPlayerTeleporting, isFalse);

        player
          ..x = game.leapMap.width
          ..update(0);

        expect(player.isPlayerTeleporting, isTrue);
      },
      // TODO(marcossevilla): Fix this test, it's failing because
      //  a class we need to mock is internal on flame_tiled.
      skip: true,
    );
  });
}
