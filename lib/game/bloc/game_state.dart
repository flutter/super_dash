part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    required this.score,
    required this.wingsQty,
    required this.currentLevel,
    required this.currentSection,
  });

  const GameState.initial()
      : score = 0,
        wingsQty = 0,
        currentLevel = 1,
        currentSection = 0;

  final int score;
  final int wingsQty;
  final int currentLevel;
  final int currentSection;

  static const maxWingsQty = 5;

  GameState copyWith({
    int? score,
    int? wingsQty,
    int? currentLevel,
    int? currentSection,
  }) {
    return GameState(
      score: score ?? this.score,
      wingsQty: wingsQty ?? this.wingsQty,
      currentLevel: currentLevel ?? this.currentLevel,
      currentSection: currentSection ?? this.currentSection,
    );
  }

  @override
  List<Object?> get props => [score, wingsQty, currentLevel, currentSection];
}
