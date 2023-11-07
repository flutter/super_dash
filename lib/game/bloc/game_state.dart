part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    required this.score,
    required this.currentLevel,
    required this.currentSection,
  });

  const GameState.initial()
      : score = 0,
        currentLevel = 1,
        currentSection = 0;

  final int score;
  final int currentLevel;
  final int currentSection;

  GameState copyWith({
    int? score,
    int? currentLevel,
    int? currentSection,
  }) {
    return GameState(
      score: score ?? this.score,
      currentLevel: currentLevel ?? this.currentLevel,
      currentSection: currentSection ?? this.currentSection,
    );
  }

  @override
  List<Object?> get props => [score, currentLevel, currentSection];
}
