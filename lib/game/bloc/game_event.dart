part of 'game_bloc.dart';

sealed class GameEvent {}

final class GameScoreIncreased extends GameEvent {
  GameScoreIncreased({this.by = 1});

  final int by;
}

final class GameScoreDecreased extends GameEvent {
  GameScoreDecreased({this.by = 1});

  final int by;
}

final class GameOver extends GameEvent {
  GameOver();
}

final class GameSectionCompleted extends GameEvent {
  GameSectionCompleted({required this.sectionCount});

  final int sectionCount;
}
