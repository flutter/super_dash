// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:super_dash/leaderboard/bloc/leaderboard_bloc.dart';

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
