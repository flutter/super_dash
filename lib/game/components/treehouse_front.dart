import 'dart:ui';

import 'package:dash_run/game/dash_run_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

typedef TreeHouseFrontRender = void Function(
  Canvas canvas,
  CameraComponent camera,
);

class TreeHouseFront extends PositionComponent with HasGameRef<DashRunGame> {
  TreeHouseFront({
    required this.renderFront,
  }) : super(priority: 1000, position: Vector2(0, 0));

  final TreeHouseFrontRender renderFront;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    renderFront(canvas, gameRef.camera);
  }
}
