import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
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

class _MockTileset extends Mock implements Tileset {}

class _MockGameBloc extends MockBloc<GameEvent, GameState>
    implements GameBloc {}

class _MockAudioController extends Mock implements AudioController {}

class _MockLeapMap extends Mock implements LeapMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _TestSuperDashGame extends SuperDashGame {
  _TestSuperDashGame({this.layerObjects = const []})
      : super(
          gameBloc: _MockGameBloc(),
          audioController: _MockAudioController(),
        );

  final List<TiledObject> layerObjects;

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

      final objectGroup = _MockObjectGroup();
      when(() => objectGroup.objects).thenReturn(layerObjects);

      when(() => map.getTileLayer<ObjectGroup>(any())).thenReturn(objectGroup);
      _leapMap = map;
    }

    return _leapMap!;
  }
}

class _ReferenceComponent extends PositionComponent {}

class _SpawnedComponent extends PositionComponent {
  _SpawnedComponent({required this.tiledObject});
  final TiledObject tiledObject;
}

void main() {
  group('ObjectGroupProximitySpawner', () {
    setUpAll(() {
      registerFallbackValue(Component());
    });

    final objects = [
      TiledObject(
        id: 1,
        x: 400,
      ),
      TiledObject(
        id: 2,
        x: 800,
      ),
    ];
    testWithGame(
      'can be added to a game',
      _TestSuperDashGame.new,
      (game) async {
        final reference = _ReferenceComponent();
        await game.world.ensureAdd(reference);

        await game.ensureAdd(
          ObjectGroupProximityBuilder<_ReferenceComponent>(
            proximity: 200,
            tileLayerName: '',
            tileset: _MockTileset(),
            componentBuilder: ({
              required TiledObject tiledObject,
            }) =>
                PositionComponent(),
          ),
        );
      },
    );

    testWithGame(
      'spawn an object when the reference is far enough',
      () => _TestSuperDashGame(layerObjects: objects),
      (game) async {
        final reference = _ReferenceComponent();
        await game.world.ensureAdd(reference);

        final proximityBuilder =
            ObjectGroupProximityBuilder<_ReferenceComponent>(
          proximity: 200,
          tileLayerName: '',
          tileset: _MockTileset(),
          componentBuilder: _SpawnedComponent.new,
        );
        await game.ensureAdd(proximityBuilder);

        reference.x = 201;

        proximityBuilder.update(0);

        await game.ready();

        verify(() => game.leapMap.add(any())).called(1);
      },
    );

    testWithGame(
      "doesn't spanw the component again",
      () => _TestSuperDashGame(layerObjects: objects),
      (game) async {
        final reference = _ReferenceComponent();
        await game.world.ensureAdd(reference);

        final proximityBuilder =
            ObjectGroupProximityBuilder<_ReferenceComponent>(
          proximity: 200,
          tileLayerName: '',
          tileset: _MockTileset(),
          componentBuilder: _SpawnedComponent.new,
        );
        await game.ensureAdd(proximityBuilder);

        reference.x = 201;

        proximityBuilder.update(0);

        await game.ready();

        verify(() => game.leapMap.add(any())).called(1);

        proximityBuilder.update(0);

        await game.ready();
        verifyNever(() => game.leapMap.add(any()));
      },
    );
  });
}
