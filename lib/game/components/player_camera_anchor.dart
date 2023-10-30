import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class PlayerCameraAnchor extends Component
    with ParentIsA<PositionComponent>
    implements ReadOnlyPositionProvider {
  PlayerCameraAnchor({
    required this.levelSize,
    required this.cameraViewport,
  });

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  final Vector2 _anchor = Vector2.zero();

  late final Vector2 _cameraMin = Vector2(
    cameraViewport.x / 2,
    cameraViewport.y / 2,
  );

  late final Vector2 _cameraMax = Vector2(
    levelSize.x - cameraViewport.x / 2,
    levelSize.y - cameraViewport.y / 2,
  );

  @override
  Vector2 get position => _anchor;

  void _setAnchor(double x, double y) {
    _anchor
      ..x = x.clamp(_cameraMin.x, _cameraMax.x)
      ..y = y.clamp(_cameraMin.y, _cameraMax.y);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final value = parent.position.clone();
    _setAnchor(value.x, value.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _setAnchor(
      parent.position.x,
      parent.position.y,
    );
  }
}
