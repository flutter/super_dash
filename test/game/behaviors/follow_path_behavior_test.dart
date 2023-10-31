import 'package:dash_run/game/game.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:pathxp/pathxp.dart';

class _TestGame extends LeapGame {
  _TestGame() : super(tileSize: 64);
}

void main() {
  group('FollowPathBehavior', () {
    testWithGame(
      'correctly calculate the path in move effects',
      _TestGame.new,
      (game) async {
        final pathxp = Pathxp('{L, R}');
        final parent = PhysicalEntity();
        final behavior = FollowPathBehavior(pathxp);

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        final sequenceEffects = parent.children.whereType<SequenceEffect>();
        expect(sequenceEffects, hasLength(1));

        final moveEffects =
            sequenceEffects.first.children.whereType<MoveEffect>();

        expect(moveEffects, hasLength(2));

        expect(moveEffects.first.measure(), equals(64));
        expect(moveEffects.last.measure(), equals(64));
      },
    );

    testWithGame(
      'correctly calculate the path with repeated steps into move effects',
      _TestGame.new,
      (game) async {
        final pathxp = Pathxp('{2L, R}');
        final parent = PhysicalEntity();
        final behavior = FollowPathBehavior(pathxp);

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        final sequenceEffects = parent.children.whereType<SequenceEffect>();
        expect(sequenceEffects, hasLength(1));

        final moveEffects =
            sequenceEffects.first.children.whereType<MoveEffect>();

        expect(moveEffects, hasLength(2));

        expect(moveEffects.first.measure(), equals(128));
        expect(moveEffects.last.measure(), equals(64));
      },
    );
  });
}
