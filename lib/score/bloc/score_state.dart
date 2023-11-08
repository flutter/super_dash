part of 'score_bloc.dart';

enum ScoreStatus {
  gameOver,
  inputInitials,
  scoreOverview,
  leaderboard,
}

enum InitialsFormStatus {
  initial,
  loading,
  success,
  invalid,
  failure,
  blacklisted,
}

class ScoreState extends Equatable {
  const ScoreState({
    this.status = ScoreStatus.gameOver,
    this.initials = const ['', '', ''],
    this.initialsStatus = InitialsFormStatus.initial,
  });

  final ScoreStatus status;
  final List<String> initials;
  final InitialsFormStatus initialsStatus;

  ScoreState copyWith({
    ScoreStatus? status,
    List<String>? initials,
    InitialsFormStatus? initialsStatus,
  }) {
    return ScoreState(
      status: status ?? this.status,
      initials: initials ?? this.initials,
      initialsStatus: initialsStatus ?? this.initialsStatus,
    );
  }

  @override
  List<Object> get props => [status, initials, initialsStatus];
}
