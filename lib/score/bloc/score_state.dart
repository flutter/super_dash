part of 'score_bloc.dart';

enum ScoreStatus {
  gameOver,
  inputInitials,
  scoreOverview,
  leaderboard,
}

class ScoreState extends Equatable {
  const ScoreState({
    this.status = ScoreStatus.scoreOverview,
    this.initials = '',
  });

  final ScoreStatus status;
  final String initials;

  ScoreState copyWith({
    ScoreStatus? status,
    String? initials,
  }) {
    return ScoreState(
      status: status ?? this.status,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object> get props => [status, initials];
}
