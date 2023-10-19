import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraDebugger extends RectangleComponent {
  CameraDebugger({
    super.position,
  }) : super(
          paint: Paint()..color = Colors.pink,
          size: Vector2.all(150),
          priority: 100,
        );

  final _direction = Vector2.zero();
  double _speed = 300;

  @override
  void update(double dt) {
    super.update(dt);

    position += _direction * _speed * dt;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

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
          LogicalKeyboardKey.space: (_) {
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
          LogicalKeyboardKey.space: (_) {
            _speed = 300;
            return false;
          },
        },
      ),
    );
  }
}
