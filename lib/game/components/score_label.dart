import 'dart:async';

import 'package:flame/components.dart';
import 'package:super_dash/game/game.dart';

class ScoreLabel extends TextComponent with HasGameRef<SuperDashGame> {
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
        '💙 ${gameRef.player?.health ?? 0} '
        '🚀 ${gameRef.player?.powerUps.length ?? 0}';
  }

  @override
  void update(double dt) {
    super.update(dt);

    _current = '${gameRef.score} '
        '💙 ${gameRef.player?.health ?? 0} '
        '🚀 ${gameRef.player?.powerUps.length ?? 0}';
    text = _current;
  }
}
