// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/leaderboard/leaderboard.dart';
import 'package:super_dash/score/score.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

class _FakeLeaderboardEntryData extends Fake implements LeaderboardEntryData {
  @override
  String get playerInitials => 'DASH';

  @override
  int get score => 42000;
}

extension on WidgetTester {
  AppLocalizations l10n<T extends Widget>() => element(find.byType(T)).l10n;
}

void main() {
  group('LeaderboardPage', () {
    test('is routable', () {
      expect(LeaderboardPage.page(), isA<MaterialPage<void>>());
      expect(LeaderboardPage.route(), isA<PageRoute<void>>());
    });

    testWidgets('renders LeaderboardView', (tester) async {
      await tester.pumpApp(LeaderboardPage());
      expect(find.byType(LeaderboardView), findsOneWidget);
    });
  });

  group('LeaderboardView', () {
    late FlowController<ScoreState> controller;
    late LeaderboardBloc leaderboardBloc;

    setUp(() {
      controller = FakeFlowController<ScoreState>(ScoreState());
      leaderboardBloc = _MockLeaderboardBloc();

      when(() => leaderboardBloc.state).thenReturn(
        const LeaderboardInitial(),
      );
    });

    Widget buildSubject({LeaderboardStep step = LeaderboardStep.gameIntro}) {
      return FlowBuilder<ScoreState>(
        controller: controller,
        onGeneratePages: (_, __) => [
          MaterialPage(
            child: BlocProvider.value(
              value: leaderboardBloc,
              child: LeaderboardView(step: step),
            ),
          ),
        ],
      );
    }

    testWidgets(
      'renders play again button when step is game score',
      (tester) async {
        await tester.pumpApp(
          buildSubject(step: LeaderboardStep.gameScore),
        );
        expect(
          find.text(tester.l10n<LeaderboardView>().playAgain),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders go back button when step is game intro',
      (tester) async {
        await tester.pumpApp(
          // ignore: avoid_redundant_argument_values
          buildSubject(step: LeaderboardStep.gameIntro),
        );
        expect(
          find.text(tester.l10n<LeaderboardView>().leaderboardPageGoBackButton),
          findsOneWidget,
        );
      },
    );

    testWidgets('renders loading widget', (tester) async {
      when(() => leaderboardBloc.state).thenReturn(LeaderboardLoading());
      await tester.pumpApp(buildSubject());
      expect(find.byType(LeaderboardLoadingWidget), findsOneWidget);
    });

    testWidgets('renders error widget', (tester) async {
      when(() => leaderboardBloc.state).thenReturn(LeaderboardError());
      await tester.pumpApp(buildSubject());
      expect(find.byType(LeaderboardErrorWidget), findsOneWidget);
    });

    testWidgets(
      'renders leaderboard empty text when entries is empty',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardLoaded(entries: const []),
        );
        await tester.pumpApp(buildSubject());
        expect(
          find.text(
            tester.l10n<LeaderboardView>().leaderboardPageLeaderboardNoEntries,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders leaderboard list when entries exist',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardLoaded(entries: [_FakeLeaderboardEntryData()]),
        );
        await tester.pumpApp(buildSubject());
        expect(
          find.byType(ListView),
          findsOneWidget,
        );
      },
    );
  });
}
