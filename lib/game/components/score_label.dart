import 'dart:async';

import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';

class ScoreLabel extends TextComponent with HasGameRef<DashRunGame> {
  ScoreLabel()
      : super(
          text: '0',
          textRenderer: TextPaint(),
        );

  late int _current;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _current = gameRef.score;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_current != gameRef.score) {
      _current = gameRef.score;
      text = _current.toString();
    }
  }
}
