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
    on<ScoreInitialsSubmitted>(_onScoreInitialsSubmitted);
  }

  final int score;
  final LeaderboardRepository _leaderboardRepository;

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
