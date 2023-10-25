import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';

class ScoreLabel extends TextComponent with HasGameRef<DashRunGame> {
  ScoreLabel({
    int initialScore = 0,
    int initialItems = 0,
    int initialHealth = Player.initialHealth,
  }) : super(
          text: '$initialScore '
              '💙 $initialHealth '
              '🚀 $initialItems',
          textRenderer: TextPaint(),
        );

  late String _current;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _current = '${gameRef.score} '
        '💙 ${gameRef.player.health} '
        '🚀 ${gameRef.player.items.length}';
  }

  @override
  void update(double dt) {
    super.update(dt);

    _current = '${gameRef.score} '
        '💙 ${gameRef.player.health} '
        '🚀 ${gameRef.player.items.length}';
    text = _current;
  }
}
