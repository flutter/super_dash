part of 'game_bloc.dart';

sealed class GameEvent {}

class GameScoreChanged extends GameEvent {
  GameScoreChanged(this.score);

  final int score;
}
