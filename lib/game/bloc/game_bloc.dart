import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameScoreIncreased>(_onGameScoreIncreased);
    on<GameScoreDecreased>(_onGameScoreDecreased);
    on<GameOver>(_onGameOver);
    on<GameSectionCompleted>(_onGameSectionCompleted);
  }

  void _onGameScoreIncreased(
    GameScoreIncreased event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        score: state.score + event.by,
      ),
    );
  }

  void _onGameScoreDecreased(
    GameScoreDecreased event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        score: state.score - event.by,
      ),
    );
  }

  void _onGameOver(
    GameOver event,
    Emitter<GameState> emit,
  ) {
    emit(const GameState.initial());
  }

  void _onGameSectionCompleted(
    GameSectionCompleted event,
    Emitter<GameState> emit,
  ) {
    if (state.currentSection < event.sectionCount - 1) {
      emit(
        state.copyWith(
          currentSection: state.currentSection + 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentSection: 0,
          currentLevel: state.currentLevel + 1,
        ),
      );
    }
  }
}
