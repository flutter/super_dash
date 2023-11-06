import 'package:dash_run/score/score.dart';
import 'package:flutter/material.dart';

List<Page<void>> onGenerateScorePages(
  ScoreState state,
  List<Page<void>> pages,
) {
  return switch (state.status) {
    // TODO(all): add game over page
    ScoreStatus.gameOver => [const MaterialPage<void>(child: Placeholder())],
    ScoreStatus.inputInitials => [InputInitialsPage.page()],
    ScoreStatus.scoreOverview => [ScoreOverviewPage.page()],
    // TODO(all): add leaderboard page
    ScoreStatus.leaderboard => [const MaterialPage<void>(child: Placeholder())],
  };
}
