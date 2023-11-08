import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:dash_run/score/score.dart';
import 'package:flame/cache.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

enum LeaderboardStep { gameIntro, gameScore }

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({
    this.step = LeaderboardStep.gameIntro,
    super.key,
  });

  static Page<void> page() {
    return const MaterialPage(
      child: LeaderboardPage(),
    );
  }

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LeaderboardPage(),
    );
  }

  final LeaderboardStep step;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: context.read<LeaderboardRepository>(),
      )..add(const LeaderboardTop10Requested()),
      child: LeaderboardView(step: step),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({
    required this.step,
    super.key,
  });

  final LeaderboardStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageWithBackground(
      background: const GameBackground(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.leaderboardBg.image(
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.sizeOf(context).height * .3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Leaderboard(),
                const SizedBox(height: 20),
                if (step == LeaderboardStep.gameScore)
                  GameElevatedButton.icon(
                    label: l10n.playAgain,
                    icon: const Icon(Icons.replay),
                    onPressed: () => context.flow<ScoreState>().complete,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .5,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4E4F65),
            Color(0xFF1B1B36),
          ],
        ),
      ),
      child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) => switch (state) {
          LeaderboardInitial() => const SizedBox.shrink(),
          LeaderboardLoading() => const Center(child: _LoadingWidget()),
          LeaderboardError() => const Center(child: _ErrorWidget()),
          LeaderboardLoaded(entries: final entries) =>
            _LeaderboardContent(entries: entries),
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 64,
          child: SpriteAnimationWidget.asset(
            images: Images(prefix: ''),
            path: Assets.map.anim.spritesheetDashDeathFaintPng.path,
            data: SpriteAnimationData.sequenced(
              amount: 16,
              stepTime: 0.042,
              textureSize: Vector2.all(64), // Game's tile size.
              amountPerRow: 8,
              loop: false,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('There was an error while fetching the leaderboard.'),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 64,
      child: SpriteAnimationWidget.asset(
        images: Images(prefix: ''),
        path: Assets.map.anim.spritesheetDashRunPng.path,
        data: SpriteAnimationData.sequenced(
          amount: 16,
          stepTime: 0.042,
          textureSize: Vector2.all(64), // Game's tile size.
          amountPerRow: 8,
        ),
      ),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  const _LeaderboardContent({required this.entries});

  final List<LeaderboardEntryData> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final listTileTheme = theme.listTileTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.leaderboardPageLeaderboardHeadline,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (entries.isEmpty)
            const Center(child: Text('No entries'))
          else
            Flexible(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries.elementAt(index);
                  return ListTile(
                    leading: Text('#${index + 1}'),
                    title: Text(entry.playerInitials),
                    trailing: Text(l10n.gameScoreLabel(entry.score)),
                    titleTextStyle: listTileTheme.titleTextStyle?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    leadingAndTrailingTextStyle:
                        listTileTheme.leadingAndTrailingTextStyle?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
