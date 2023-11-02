part of 'game_bloc.dart';

class GameState {
  const GameState({required this.score});

  const GameState.initial() : score = 0;

  final int score;

  GameState copyWith({int? score}) {
    return GameState(
      score: score ?? this.score,
    );
  }
}
