// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/game.dart';

class _MockGameBloc extends MockBloc<GameEvent, GameState>
    implements GameBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SuperDashGame', () {
    late GameBloc gameBloc;
    late AudioController audioController;

    setUp(() {
      gameBloc = _MockGameBloc();
      audioController = _MockAudioController();

      when(() => gameBloc.state).thenReturn(const GameState.initial());
    });

    SuperDashGame createGame() {
      return SuperDashGame(
        gameBloc: gameBloc,
        audioController: audioController,
      );
    }

    final flameTester = FlameTester(createGame);

    flameTester.testGameWidget(
      'starts with score 0',
      setUp: (game, tester) async {
        when(() => game.gameBloc.state).thenReturn(const GameState.initial());
        await game.ready();
      },
      verify: (game, tester) async => expect(
        game.gameBloc.state.score,
        isZero,
      ),
    );

    flameTester.testGameWidget(
      'starts with player',
      setUp: (game, tester) async {
        await game.ready();
      },
      verify: (game, tester) async => expect(
        game.world.descendants().whereType<Player>(),
        isNotNull,
      ),
    );

    flameTester.testGameWidget(
      'starts with an input',
      setUp: (game, tester) async {
        await game.ready();
      },
      verify: (game, tester) async => expect(
        game.descendants().whereType<KeyboardListenerComponent>(),
        isNotNull,
      ),
    );

    testWithGame(
      'starts with correct amount of items',
      createGame,
      (game) async {
        await game.ready();
        expect(
          game.leapMap.children.whereType<Item>().length,
          equals(33),
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
      skip: true, // TODO(all): This test is flaky, skipping it for now
    );

    testWithGame(
      'starts with 0 enemies spawned',
      createGame,
      (game) async {
        await game.ready();
        expect(
          game.leapMap.children.whereType<Enemy>().length,
          isZero,
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
      skip: true, // TODO(all): This test is flaky, skipping it for now
    );
  });
}
