// ignore_for_file: prefer_const_constructors

import 'package:dash_run/game/dash_run_game.dart';
import 'package:dash_run/map_tester/map_tester.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('MapTesterView', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(MapTesterView());

      expect(find.byType(MapTesterView), findsOneWidget);
    });

    testWidgets('allows to select a game folder', (tester) async {
      Future<String> getDirectoryPath() async => '.';

      await tester.pumpApp(
        MapTesterView(
          selectGameFolder: getDirectoryPath,
        ),
      );

      await tester.tap(find.text('Load folder'));
      await tester.pump();

      expect(
        find.byType(GameWidget<DashRunGame>),
        findsOneWidget,
      );
    });

    testWidgets('can unload the game', (tester) async {
      Future<String> getDirectoryPath() async => '.';

      await tester.pumpApp(
        MapTesterView(
          selectGameFolder: getDirectoryPath,
        ),
      );

      await tester.tap(find.text('Load folder'));
      await tester.pump();

      expect(
        find.byType(GameWidget<DashRunGame>),
        findsOneWidget,
      );

      await tester.tap(find.text('Unload'));
      await tester.pump();

      expect(
        find.byType(GameWidget<DashRunGame>),
        findsNothing,
      );
    });

    testWidgets('allows to reload a game', (tester) async {
      Future<String> getDirectoryPath() async => '.';

      await tester.pumpApp(
        MapTesterView(
          selectGameFolder: getDirectoryPath,
        ),
      );

      await tester.tap(find.text('Load folder'));
      await tester.pump();

      var widget = tester.widget<GameWidget<DashRunGame>>(
        find.byType(GameWidget<DashRunGame>),
      );

      final originalGame = widget.game;
      expect(originalGame, isNotNull);

      await tester.tap(find.text('Reload'));
      await tester.pump();

      widget = tester.widget<GameWidget<DashRunGame>>(
        find.byType(GameWidget<DashRunGame>),
      );

      final updatedGame = widget.game;
      expect(updatedGame, isNotNull);
      expect(updatedGame, isNot(originalGame));
    });
  });
}
