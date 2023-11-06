import 'package:dash_run/score/bloc/score_bloc.dart';
import 'package:dash_run/score/routes/routes.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    required this.score,
    super.key,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScoreBloc(
        score: score,
        leaderboardRepository: context.read<LeaderboardRepository>(),
      ),
      child: const ScoreView(),
    );
  }
}

class ScoreView extends StatelessWidget {
  const ScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowBuilder(
      state: context.watch<ScoreBloc>().state,
      onGeneratePages: onGenerateScorePages,
    );
  }
}
