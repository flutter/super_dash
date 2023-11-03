// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends MockBloc<GameEvent, GameState>
    implements GameBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  late SettingsController settingsController;

  setUp(() {
    settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
  });

  group('Game', () {
    test('is routable', () {
      expect(Game.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders GameView', (tester) async {
      await tester.pumpApp(
        Game(),
        settingsController: settingsController,
      );

      expect(find.byType(GameView), findsOneWidget);
    });
  });

  group('GameView', () {
    late GameBloc gameBloc;

    setUp(() => gameBloc = _MockGameBloc());

    Widget buildSubject() {
      return BlocProvider.value(
        value: gameBloc,
        child: const GameView(),
      );
    }

    testWidgets('renders score', (tester) async {
      when(() => gameBloc.state).thenReturn(GameState(score: 100));

      await tester.pumpApp(
        buildSubject(),
        settingsController: settingsController,
      );

      expect(
        find.text('${gameBloc.state.score} Pts'),
        findsOneWidget,
      );
    });
  });
}
