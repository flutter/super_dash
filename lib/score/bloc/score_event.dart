part of 'score_bloc.dart';

sealed class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

final class ScoreInitialsSubmitted extends ScoreEvent {
  const ScoreInitialsSubmitted({required this.initials});

  final String initials;

  @override
  List<Object> get props => [initials];
}

final class ScoreLeaderboardRequested extends ScoreEvent {
  const ScoreLeaderboardRequested();
}
