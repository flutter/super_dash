part of 'game_bloc.dart';

sealed class GameEvent {}

final class GameScoreReset extends GameEvent {
  GameScoreReset();
}

final class GameScoreIncreased extends GameEvent {
  GameScoreIncreased({this.by = 1});

  final int by;
}

final class GameScoreDecreased extends GameEvent {
  GameScoreDecreased({this.by = 1});

  final int by;
}
