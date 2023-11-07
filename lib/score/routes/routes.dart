import 'package:dash_run/leaderboard/leaderboard.dart';
import 'package:dash_run/score/game_over/game_over.dart';
import 'package:dash_run/score/score.dart';
import 'package:flutter/material.dart';

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
