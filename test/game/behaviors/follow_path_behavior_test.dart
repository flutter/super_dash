import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pathxp/pathxp.dart';
import 'package:super_dash/game/game.dart';

class _MockSprite extends Mock implements Sprite {}

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
        final parent = LeapMapGroundTile(Tile(localId: 0), 0, 0);
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
        final parent = LeapMapGroundTile(Tile(localId: 0), 0, 0);
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

    testWithGame(
      'flips the parent sprite when it changes direction',
      _TestGame.new,
      (game) async {
        final pathxp = Pathxp('{L, R}');
        final parent = LeapMapGroundTile(Tile(localId: 0), 0, 0);
        final behavior = FollowPathBehavior(pathxp);

        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        final sprite = _MockSprite();
        when(() => sprite.srcSize).thenReturn(Vector2(1, 1));
        final spriteComponent = SpriteComponent()..sprite = sprite;
        await parent.ensureAdd(spriteComponent);

        expect(spriteComponent.isFlippedHorizontally, isFalse);

        var timeElapsed = 0.0;

        while (timeElapsed < 8) {
          behavior.update(.1);
          parent.updateTree(.1);
          timeElapsed += .1;
        }

        expect(spriteComponent.isFlippedHorizontally, isTrue);
      },
    );
  });
}
