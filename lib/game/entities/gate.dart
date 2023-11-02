import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:super_dash/game/game.dart';

class Gate extends SpriteComponent with HasGameRef<SuperDashGame> {
  late int _currentLevel;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final gateLayer = gameRef.leapMap.getTileLayer<ObjectGroup>('gate');
    final tiledObject = gateLayer.objects.first;

    sprite = await gameRef.loadSprite('../images/gate.png');
    size = sprite!.srcSize;
    position = Vector2(
          tiledObject.x,
          tiledObject.y,
        ) +
        Vector2.all(gameRef.tileSize);
    anchor = Anchor.bottomLeft;

    _currentLevel = gameRef.currentLevel;

    add(
      TextComponent(
        text: _currentLevel.toString(),
        position: Vector2(size.x / 2 - 8, 88),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.currentLevel != _currentLevel) {
      _currentLevel = gameRef.currentLevel;
      firstChild<TextComponent>()?.text = _currentLevel.toString();
    }
  }
}
