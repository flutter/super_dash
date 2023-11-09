// ignore_for_file: prefer_const_constructors

import 'package:dash_run/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LeaderboardTop10Requested', () {
    test(
      'supports value equality',
      () => expect(
        LeaderboardTop10Requested(),
        LeaderboardTop10Requested(),
      ),
    );
  });
}
