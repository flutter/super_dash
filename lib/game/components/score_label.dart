import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';

class ScoreLabel extends TextComponent with HasGameRef<DashRunGame> {
  ScoreLabel()
      : super(
          text: '0 - ${Player.initialHealth}',
          textRenderer: TextPaint(),
        );

  late String _current;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _current = '${gameRef.score} - 💙 ${gameRef.player.health}';
  }

  @override
  void update(double dt) {
    super.update(dt);

    _current = '${gameRef.score} - 💙 ${gameRef.player.health}';
    text = _current;
  }
}
