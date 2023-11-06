import 'package:bloc_test/bloc_test.dart';
import 'package:dash_run/game/bloc/game_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameBloc', () {
    blocTest<GameBloc, GameState>(
      'emits GameState with new score when GameScoreChanged is added',
      build: GameBloc.new,
      seed: () => const GameState(score: 100),
      act: (bloc) => bloc.add(GameScoreReset()),
      expect: () => const [GameState.initial()],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with score increased correctly '
      'when GameScoreIncreased is added',
      build: GameBloc.new,
      seed: () => const GameState(score: 100),
      act: (bloc) => bloc.add(GameScoreIncreased(by: 2)),
      expect: () => const [GameState(score: 102)],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with score decreased correctly '
      'when GameScoreDecreased is added',
      build: GameBloc.new,
      seed: () => const GameState(score: 100),
      act: (bloc) => bloc.add(GameScoreDecreased(by: 2)),
      expect: () => const [GameState(score: 98)],
    );
  });
}
