// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/leaderboard/bloc/leaderboard_bloc.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _FakeLeaderboardEntryData extends Fake implements LeaderboardEntryData {}

void main() {
  group('LeaderboardBloc', () {
    late LeaderboardRepository leaderboardRepository;
    late LeaderboardEntryData leaderboardEntryData;

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      leaderboardEntryData = _FakeLeaderboardEntryData();
    });

    test(
      'default state is LeaderboardInitial',
      () => expect(
        LeaderboardBloc(leaderboardRepository: leaderboardRepository).state,
        isA<LeaderboardInitial>(),
      ),
    );

    blocTest<LeaderboardBloc, LeaderboardState>(
      'emits [LeaderboardLoading, LeaderboardLoaded] '
      'when LeaderboardTop10Requested is added and repository returns data',
      setUp: () {
        when(leaderboardRepository.fetchTop10Leaderboard).thenAnswer(
          (_) async => [leaderboardEntryData],
        );
      },
      build: () => LeaderboardBloc(
        leaderboardRepository: leaderboardRepository,
      ),
      act: (bloc) => bloc.add(LeaderboardTop10Requested()),
      expect: () => [
        LeaderboardLoading(),
        LeaderboardLoaded(entries: [leaderboardEntryData]),
      ],
    );

    blocTest<LeaderboardBloc, LeaderboardState>(
      'emits [LeaderboardLoading, LeaderboardError] '
      'when LeaderboardTop10Requested is added and repository fails',
      setUp: () {
        when(
          leaderboardRepository.fetchTop10Leaderboard,
        ).thenThrow(Exception());
      },
      build: () => LeaderboardBloc(
        leaderboardRepository: leaderboardRepository,
      ),
      act: (bloc) => bloc.add(LeaderboardTop10Requested()),
      expect: () => [
        LeaderboardLoading(),
        LeaderboardError(),
      ],
    );
  });
}
