import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc({
    required this.score,
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        super(const ScoreState()) {
    on<ScoreSubmitted>(_onScoreSubmitted);
    on<ScoreInitialsSubmitted>(_onScoreInitialsSubmitted);
  }

  final int score;
  final LeaderboardRepository _leaderboardRepository;

  void _onScoreSubmitted(
    ScoreSubmitted event,
    Emitter<ScoreState> emit,
  ) {
    emit(
      state.copyWith(
        status: ScoreStatus.inputInitials,
      ),
    );
  }

  Future<void> _onScoreInitialsSubmitted(
    ScoreInitialsSubmitted event,
    Emitter<ScoreState> emit,
  ) async {
    // TODO(all): add try-catch
    await _leaderboardRepository.addLeaderboardEntry(
      LeaderboardEntryData(
        playerInitials: event.initials,
        score: score,
      ),
    );
  }
}
