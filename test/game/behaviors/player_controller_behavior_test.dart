import 'package:dash_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimpleCombinedInput extends Mock implements SimpleCombinedInput {}

class _TestDashRunGame extends DashRunGame {
  @override
  Future<void> onLoad() async {
    // Noop
  }
}

class _TestPlayer extends Player {
  _TestPlayer({
    bool isAlive = true,
    bool isOnGround = true,
  })  : _isAlive = isAlive,
        _isOnGround = isOnGround,
        super(
          cameraViewport: Vector2.all(200),
          levelSize: Vector2.all(200),
        );

  final bool _isAlive;
  final bool _isOnGround;

  @override
  bool get isAlive => _isAlive;

  @override
  bool get isOnGround => _isOnGround;

  @override
  Future<void> onLoad() async {
    // Noop
  }
}

void main() {
  group('PlayerControllerBehavior', () {
    testWithGame(
      'can be attached to player',
      _TestDashRunGame.new,
      (game) async {
        final input = _MockSimpleCombinedInput();

        final player = _TestPlayer()..input = input;
        await game.ensureAdd(player);

        final playerControllerBehavior = PlayerControllerBehavior();
        await player.ensureAdd(playerControllerBehavior);

        expect(playerControllerBehavior.mounted, completes);
      },
    );

    testWithGame(
      'when the player is alive, jumping, on the groupd and input is '
      'pressed, continue to jump',
      _TestDashRunGame.new,
      (game) async {
        final input = _MockSimpleCombinedInput();

        final player = _TestPlayer()
          ..input = input
          ..jumping = true;

        when(() => input.isPressed).thenReturn(true);
        when(() => input.justPressed).thenReturn(false);

        await game.ensureAdd(player);

        final playerControllerBehavior = PlayerControllerBehavior();
        await player.ensureAdd(playerControllerBehavior);

        playerControllerBehavior.update(0);

        expect(player.jumping, isTrue);
      },
    );

    testWithGame(
      'when the player is alive, jumping, on the ground but input is not '
      'pressed, stop jumping',
      _TestDashRunGame.new,
      (game) async {
        final input = _MockSimpleCombinedInput();

        final player = _TestPlayer()
          ..input = input
          ..jumping = true;

        when(() => input.isPressed).thenReturn(false);
        when(() => input.justPressed).thenReturn(false);

        await game.ensureAdd(player);

        final playerControllerBehavior = PlayerControllerBehavior();
        await player.ensureAdd(playerControllerBehavior);

        playerControllerBehavior.update(0);

        expect(player.jumping, isFalse);
      },
    );

    testWithGame(
      'when the player is alive, not jumping, not on the ground and input is '
      "pressed, don't jump",
      _TestDashRunGame.new,
      (game) async {
        final input = _MockSimpleCombinedInput();

        final player = _TestPlayer(isOnGround: false)
          ..input = input
          ..jumping = false;

        when(() => input.isPressed).thenReturn(false);
        when(() => input.justPressed).thenReturn(false);

        await game.ensureAdd(player);

        final playerControllerBehavior = PlayerControllerBehavior();
        await player.ensureAdd(playerControllerBehavior);

        playerControllerBehavior.update(0);

        expect(player.jumping, isFalse);
      },
    );

    group('when a input was just pressed', () {
      testWithGame(
        'starts to walk when the input is right and the player is not walking',
        _TestDashRunGame.new,
        (game) async {
          final input = _MockSimpleCombinedInput();

          final player = _TestPlayer(isOnGround: false)
            ..input = input
            ..walking = false;

          when(() => input.isPressed).thenReturn(false);
          when(() => input.justPressed).thenReturn(true);
          when(() => input.isPressedRight).thenReturn(true);

          await game.ensureAdd(player);

          final playerControllerBehavior = PlayerControllerBehavior();
          await player.ensureAdd(playerControllerBehavior);

          playerControllerBehavior.update(0);

          expect(player.walking, isTrue);
        },
      );

      testWithGame(
        'jumps when is moving, not facing left and on the ground',
        _TestDashRunGame.new,
        (game) async {
          final input = _MockSimpleCombinedInput();

          final player = _TestPlayer()
            ..input = input
            ..jumping = false
            ..walking = true;

          when(() => input.isPressed).thenReturn(false);
          when(() => input.justPressed).thenReturn(true);
          when(() => input.isPressedRight).thenReturn(true);

          await game.ensureAdd(player);

          final playerControllerBehavior = PlayerControllerBehavior();
          await player.ensureAdd(playerControllerBehavior);

          playerControllerBehavior.update(0);

          expect(player.jumping, isTrue);
        },
      );

      testWithGame(
        'when not facing right, just stops and turns',
        _TestDashRunGame.new,
        (game) async {
          final input = _MockSimpleCombinedInput();

          final player = _TestPlayer()
            ..input = input
            ..jumping = false
            ..walking = true
            ..faceLeft = true;

          when(() => input.isPressed).thenReturn(false);
          when(() => input.justPressed).thenReturn(true);
          when(() => input.isPressedRight).thenReturn(true);

          await game.ensureAdd(player);

          final playerControllerBehavior = PlayerControllerBehavior();
          await player.ensureAdd(playerControllerBehavior);

          playerControllerBehavior.update(0);

          expect(player.faceLeft, isFalse);
        },
      );
    });
  });
}
