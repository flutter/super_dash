import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

class _MockImage extends Mock implements Image {}

class _MockImages extends Mock implements Images {}

class _MockAudioController extends Mock implements AudioController {}

class _MockLeapMap extends Mock implements LeapMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _TestSuperDashGame extends SuperDashGame {
  _TestSuperDashGame({
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

      when(() => map.width).thenReturn(100);
      when(() => map.height).thenReturn(100);

      final spawnGroup = _MockObjectGroup();
      when(() => spawnGroup.objects).thenReturn(spawnObects);

      final respawnGroup = _MockObjectGroup();
      when(() => respawnGroup.objects).thenReturn(respawnObects);

      when(() => map.getTileLayer<ObjectGroup>('spawn')).thenReturn(spawnGroup);
      when(() => map.getTileLayer<ObjectGroup>('respawn'))
          .thenReturn(respawnGroup);
      _leapMap = map;
    }

    return _leapMap!;
  }

  @override
  SimpleCombinedInput get input => SimpleCombinedInput();
}

void main() {
  group('Player', () {
    _TestSuperDashGame createGame() {
      return _TestSuperDashGame(
        audioController: _MockAudioController(),
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
    );
  });
}
