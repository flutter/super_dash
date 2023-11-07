import 'package:dash_run/score/game_over/game_over.dart';
import 'package:dash_run/score/score.dart';
import 'package:flutter/material.dart';

List<Page<void>> onGenerateScorePages({
  required int score,
  required ScoreState state,
  required List<Page<void>> pages,
}) {
  return switch (state.status) {
    ScoreStatus.gameOver => [GameOverPage.page(score: score)],
    ScoreStatus.inputInitials => [InputInitialsPage.page()],
    ScoreStatus.scoreOverview => [ScoreOverviewPage.page()],
    // TODO(all): add leaderboard page
    ScoreStatus.leaderboard => [const MaterialPage<void>(child: Placeholder())],
  };
}
