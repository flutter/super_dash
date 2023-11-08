part of 'score_bloc.dart';

sealed class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

final class ScoreSubmitted extends ScoreEvent {
  const ScoreSubmitted();
}

final class ScoreInitialsUpdated extends ScoreEvent {
  const ScoreInitialsUpdated({required this.character, required this.index});

  final String character;

  final int index;
}

final class ScoreInitialsSubmitted extends ScoreEvent {
  const ScoreInitialsSubmitted();
}

final class ScoreLeaderboardRequested extends ScoreEvent {
  const ScoreLeaderboardRequested();
}
