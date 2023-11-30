import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:super_dash/game/super_dash_game.dart';

class TreeSign extends TextComponent with HasGameRef<SuperDashGame> {
  TreeSign({
    super.position,
  }) : super(
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Color(0xffffffff),
              fontSize: 24,
              fontFamily: 'Google Sans',
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final currentLevel = gameRef.state.currentLevel;
    text = 'DAY $currentLevel';
  }
}
