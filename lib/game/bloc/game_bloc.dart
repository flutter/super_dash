import 'package:bloc/bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameScoreChanged>(_onGameScoreChanged);
  }

  void _onGameScoreChanged(
    GameScoreChanged event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(score: event.score));
  }
}
