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

  ScoreState copyWith({
    ScoreStatus? status,
  }) {
    return ScoreState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
