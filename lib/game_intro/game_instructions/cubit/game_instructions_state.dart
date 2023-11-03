part of 'game_instructions_cubit.dart';

enum GameInstructionsStep {
  autoRun,
  tapToJump,
  collectEggsAndAcorns,
  powerfulWings,
  levelGates,
  avoidBugs,
}

class GameInstructionsState extends Equatable {
  const GameInstructionsState(this.currentStep);

  final GameInstructionsStep currentStep;

  @override
  List<Object> get props => [currentStep];
}
