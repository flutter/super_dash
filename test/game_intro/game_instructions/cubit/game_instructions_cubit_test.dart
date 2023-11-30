import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_dash/game_intro/game_instructions/cubit/game_instructions_cubit.dart';

void main() {
  group('GameInstructionsCubit', () {
    blocTest<GameInstructionsCubit, GameInstructionsState>(
      'emits correct step when updateStep is called',
      build: GameInstructionsCubit.new,
      act: (cubit) => cubit.updateStep(GameInstructionsStep.tapToJump.index),
      expect: () => const [
        GameInstructionsState(GameInstructionsStep.tapToJump),
      ],
    );
  });
}
