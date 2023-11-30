import 'package:flutter/material.dart';
import 'package:super_dash/leaderboard/leaderboard.dart';
import 'package:super_dash/score/game_over/game_over.dart';
import 'package:super_dash/score/score.dart';

List<Page<void>> onGenerateScorePages(
  ScoreState state,
  List<Page<void>> pages,
) {
  return switch (state.status) {
    ScoreStatus.gameOver => [GameOverPage.page()],
    ScoreStatus.inputInitials => [InputInitialsPage.page()],
    ScoreStatus.scoreOverview => [ScoreOverviewPage.page()],
    ScoreStatus.leaderboard => [LeaderboardPage.page()],
  };
}
