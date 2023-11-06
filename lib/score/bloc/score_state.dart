part of 'score_bloc.dart';

enum ScoreStatus {
  gameOver,
  inputInitials,
  scoreOverview,
  leaderboard,
}

class ScoreState extends Equatable {
  const ScoreState({
    this.status = ScoreStatus.gameOver,
  });

  final ScoreStatus status;

  @override
  List<Object> get props => [status];
}
