// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';
import 'package:mocktail/mocktail.dart';

class _MockGameBloc extends MockBloc<GameEvent, GameState>
    implements GameBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashRunGame', () {
    DashRunGame createGame() {
      return DashRunGame(
        gameBloc: _MockGameBloc(),
        audioController: _MockAudioController(),
      );
    }

    final flameTester = FlameTester(createGame);

    flameTester.testGameWidget(
      'starts with score 0',
      setUp: (game, tester) async {
        await game.ready();
        when(() => game.gameBloc.state).thenReturn(const GameState.initial());
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
        game.descendants().whereType<SimpleCombinedInput>(),
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
          equals(109),
        );
      },
      timeout: const Timeout(Duration(minutes: 1)),
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
      timeout: const Timeout(Duration(minutes: 1)),
    );
  });
}
