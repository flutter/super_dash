// ignore_for_file: cascade_invocations

import 'package:dash_run/game/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leap/leap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashRunGame', () {
    final flameTester = FlameTester(DashRunGame.new);

    flameTester.testGameWidget(
      'starts with score 0',
      setUp: (game, tester) async {
        await game.ready();
      },
      verify: (game, tester) async => expect(game.score, isZero),
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
      DashRunGame.new,
      (game) async {
        await game.ready();
        expect(
          game.leapMap.children.whereType<Item>().length,
          equals(65),
        );
      },
    );

    testWithGame(
      'starts with correct amount of enemies',
      DashRunGame.new,
      (game) async {
        await game.ready();
        expect(
          game.leapMap.children.whereType<Enemy>().length,
          equals(46),
        );
      },
    );
  });
}
