import 'dart:async';
import 'dart:ui';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';

typedef ObjectGroupProximitySpawner = PositionComponent Function({
  required TiledObject tiledObject,
  required Sprite sprite,
});

class ObjectGroupProximityBuilder extends Component
    with HasGameRef<DashRunGame> {
  ObjectGroupProximityBuilder({
    required this.tileset,
    required this.leapMap,
    required this.tileLayerName,
    required this.tilesetPath,
    required this.reference,
    required this.proximity,
    required this.componentBuilder,
  });

  final Tileset tileset;
  final LeapMap leapMap;
  final String tileLayerName;
  final String tilesetPath;
  final ObjectGroupProximitySpawner componentBuilder;
  final PositionComponent reference;
  final double proximity;

  late final Image itemTiles;
  late SpriteSheet spritesheet;
  late int firstGId;

  final _objects = OrderedSet<TiledObject>(
    Comparing.on((object) => object.x),
  );

  var _referenceIndex = 0;
  var _lastReferenceX = 0.0;
  var _referenceDirection = 1;

  final List<PositionComponent> _spawnedComponents = [];

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    firstGId = tileset.firstGid ?? 0;
    final itemsLayer = gameRef.leapMap.getTileLayer<ObjectGroup>(tileLayerName);
    itemTiles = await gameRef.images.load(
      tilesetPath,
    );

    spritesheet = SpriteSheet(
      image: itemTiles,
      srcSize: Vector2.all(gameRef.tileSize),
    );

    _objects.addAll(itemsLayer.objects);

    _lastReferenceX = reference.x;
    _findPlayerIndex();
  }

  void _findPlayerIndex() {
    var i = _referenceIndex + _referenceDirection;

    if (i != _referenceIndex) {
      while (i >= 0 && i < _objects.length) {
        final object = _objects.elementAt(i);
        if (object.x > reference.x) {
          _referenceIndex = i - _referenceDirection;
          break;
        }
        i += _referenceDirection;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _referenceDirection = reference.x > _lastReferenceX
        ? 1
        : reference.x < _lastReferenceX
            ? -1
            : 0;

    _lastReferenceX = reference.x;

    if (_referenceDirection != 0) {
      _findPlayerIndex();

      for (final component in _spawnedComponents) {
        if ((component.x - reference.x).abs() > proximity) {
          component
            ..removeFromParent()
            ..removed.then((_) => _spawnedComponents.remove(component));
        }
      }

      for (var i = _referenceIndex;
          i >= 0 && i < _objects.length;
          i += _referenceDirection) {
        final object = _objects.elementAt(i);
        if ((object.x - reference.x).abs() > proximity) {
          break;
        }

        if (_spawnedComponents.any((component) => component.x == object.x)) {
          continue;
        }

        final component = componentBuilder(
          tiledObject: object,
          sprite: spritesheet.getSpriteById(
            (object.gid ?? 0) - firstGId,
          ),
        );

        _spawnedComponents.add(component);
        gameRef.leapMap.add(component);
      }
    }
  }
}
