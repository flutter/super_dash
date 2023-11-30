// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/game_intro/game_instructions/game_instructions.dart';

import '../../../helpers/helpers.dart';

class _MockGameInstructionsCubit extends MockCubit<GameInstructionsState>
    implements GameInstructionsCubit {}

void main() {
  group('GameInstructionsOverlay', () {
    test(
      'is routable',
      () => expect(
        GameInstructionsOverlay.route(),
        isA<HeroDialogRoute<void>>(),
      ),
    );

    testWidgets('renders GameInstructionsOverlayView', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpApp(GameInstructionsOverlay());

      expect(find.byType(GameInstructionsOverlayView), findsOneWidget);
    });
  });

  group('GameInstructionsOverlayView', () {
    late GameInstructionsCubit cubit;

    setUp(() {
      cubit = _MockGameInstructionsCubit();

      when(() => cubit.state).thenReturn(
        GameInstructionsState(GameInstructionsStep.autoRun),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: cubit,
        child: const GameInstructionsOverlayView(),
      );
    }

    testWidgets('renders PageView', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpApp(buildSubject());

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });
  });
}
