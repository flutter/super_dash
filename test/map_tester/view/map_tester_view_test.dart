// ignore_for_file: prefer_const_constructors

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game/super_dash_game.dart';
import 'package:super_dash/map_tester/map_tester.dart';
import 'package:super_dash/settings/settings_controller.dart';

import '../../helpers/helpers.dart';

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('MapTesterView', () {
    late SettingsController settingsController;

    setUp(() {
      settingsController = _MockSettingsController();
      when(() => settingsController.muted).thenReturn(ValueNotifier(true));
      when(() => settingsController.musicOn).thenReturn(ValueNotifier(false));
      when(() => settingsController.soundsOn).thenReturn(ValueNotifier(false));
    });

    testWidgets('renders', (tester) async {
      await tester.pumpSubject(
        () async => '',
        settingsController: settingsController,
      );

      expect(find.byType(MapTesterView), findsOneWidget);
    });

    testWidgets('allows to select a game folder', (tester) async {
      tester.setViewSize();

      Future<String> getDirectoryPath() async => '.';

      await tester.pumpSubject(
        getDirectoryPath,
        settingsController: settingsController,
      );

      await tester.tap(find.text('Load'));
      await tester.pump();

      expect(
        find.byType(GameWidget<SuperDashGame>),
        findsOneWidget,
      );
    });

    testWidgets('can unload the game', (tester) async {
      tester.setViewSize();
      Future<String> getDirectoryPath() async => '.';

      await tester.pumpSubject(
        getDirectoryPath,
        settingsController: settingsController,
      );

      await tester.tap(find.text('Load'));
      await tester.pump();

      expect(
        find.byType(GameWidget<SuperDashGame>),
        findsOneWidget,
      );

      await tester.tap(find.text('Unload'));
      await tester.pump();

      expect(
        find.byType(GameWidget<SuperDashGame>),
        findsNothing,
      );
    });

    testWidgets('allows to reload a game', (tester) async {
      tester.setViewSize();
      Future<String> getDirectoryPath() async => '.';

      await tester.pumpSubject(
        getDirectoryPath,
        settingsController: settingsController,
      );

      await tester.tap(find.text('Load'));
      await tester.pump();

      var widget = tester.widget<GameWidget<SuperDashGame>>(
        find.byType(GameWidget<SuperDashGame>),
      );

      final originalGame = widget.game;
      expect(originalGame, isNotNull);

      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      widget = tester.widget<GameWidget<SuperDashGame>>(
        find.byType(GameWidget<SuperDashGame>),
      );

      final updatedGame = widget.game;
      expect(updatedGame, isNotNull);
      expect(updatedGame, isNot(originalGame));
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Future<String> Function() getDirectoryPath, {
    AudioController? audioController,
    SettingsController? settingsController,
  }) async {
    await pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: audioController ?? _MockAudioController(),
          ),
          RepositoryProvider.value(
            value: settingsController ?? _MockSettingsController(),
          ),
        ],
        child: MapTesterView(
          selectGameFolder: getDirectoryPath,
          timer: Future.value,
        ),
      ),
    );
  }
}
