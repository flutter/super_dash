import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameScoreReset>(_onGameScoreReset);
    on<GameScoreIncreased>(_onGameScoreIncreased);
    on<GameScoreDecreased>(_onGameScoreDecreased);
  }

  void _onGameScoreReset(
    GameScoreReset event,
    Emitter<GameState> emit,
  ) {
    emit(const GameState.initial());
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
}
