import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraDebugger extends RectangleComponent {
  CameraDebugger({
    super.position,
  }) : super(
          paint: Paint()..color = Colors.pink.withOpacity(0.5),
          size: Vector2.all(150),
          priority: 100,
          anchor: Anchor.center,
        );

  final _direction = Vector2.zero();
  late final TextComponent _text;
  double _speed = 300;

  double get speed => _speed;

  @override
  void update(double dt) {
    super.update(dt);

    position += _direction * _speed * dt;

    _text.text = 'X: ${position.x.toStringAsFixed(2)}'
        '\nY: ${position.y.toStringAsFixed(2)}'
        '\nSpeed: $speed';
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      _text = TextComponent(
        anchor: Anchor.center,
        position: size / 2,
      ),
    );

    add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.keyW: (_) {
            _direction.y = -1;
            return false;
          },
          LogicalKeyboardKey.keyS: (_) {
            _direction.y = 1;
            return false;
          },
          LogicalKeyboardKey.keyA: (_) {
            _direction.x = -1;
            return false;
          },
          LogicalKeyboardKey.keyD: (_) {
            _direction.x = 1;
            return false;
          },
          LogicalKeyboardKey.keyM: (_) {
            _speed = 900;
            return false;
          },
        },
        keyUp: {
          LogicalKeyboardKey.keyW: (_) {
            if (_direction.y == -1) {
              _direction.y = 0;
            }
            return false;
          },
          LogicalKeyboardKey.keyS: (_) {
            if (_direction.y == 1) {
              _direction.y = 0;
            }
            return false;
          },
          LogicalKeyboardKey.keyA: (_) {
            if (_direction.x == -1) {
              _direction.x = 0;
            }
            return false;
          },
          LogicalKeyboardKey.keyD: (_) {
            if (_direction.x == 1) {
              _direction.x = 0;
            }
            return false;
          },
          LogicalKeyboardKey.keyM: (_) {
            _speed = 300;
            return false;
          },
        },
      ),
    );
  }
}
