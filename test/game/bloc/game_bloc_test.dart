// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_dash/game/bloc/game_bloc.dart';

void main() {
  group('GameBloc', () {
    blocTest<GameBloc, GameState>(
      'emits GameState initial when GameOver is added',
      build: GameBloc.new,
      seed: () => const GameState(
        score: 100,
        currentLevel: 2,
        currentSection: 2,
        wingsQty: 2,
      ),
      act: (bloc) => bloc.add(GameOver()),
      expect: () => const [GameState.initial()],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with score increased correctly '
      'when GameScoreIncreased is added',
      build: GameBloc.new,
      seed: () => const GameState.initial().copyWith(score: 100),
      act: (bloc) => bloc.add(GameScoreIncreased(by: 2)),
      expect: () => [const GameState.initial().copyWith(score: 102)],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with score decreased correctly '
      'when GameScoreDecreased is added',
      build: GameBloc.new,
      seed: () => const GameState.initial().copyWith(score: 100),
      act: (bloc) => bloc.add(GameScoreDecreased(by: 2)),
      expect: () => [const GameState.initial().copyWith(score: 98)],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with wings increased correctly '
      'when dash collect a wing',
      build: GameBloc.new,
      seed: () => const GameState.initial().copyWith(wingsQty: 1),
      act: (bloc) => bloc.add(GameWingsIncreased()),
      expect: () => [const GameState.initial().copyWith(wingsQty: 2)],
    );

    blocTest<GameBloc, GameState>(
      'emits GameState with wings decreased correctly '
      'when dash lost a wing',
      build: GameBloc.new,
      seed: () => const GameState.initial().copyWith(wingsQty: 1),
      act: (bloc) => bloc.add(GameWingsDecreased()),
      expect: () => [const GameState.initial().copyWith(wingsQty: 0)],
    );

    blocTest<GameBloc, GameState>(
      'not emits GameState when dash collect a '
          'new wing and exceed the max wings qty',
      build: GameBloc.new,
      seed: () => const GameState.initial().copyWith(
        wingsQty: GameState.maxWingsQty,
      ),
      act: (bloc) => bloc.add(GameWingsIncreased()),
      expect: () => <GameState>[],
    );
  });
}
