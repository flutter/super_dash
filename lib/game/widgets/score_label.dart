import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_dash/game/bloc/game_bloc.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';

class ScoreLabel extends StatelessWidget {
  const ScoreLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final score = context.select(
      (GameBloc bloc) => bloc.state.score,
    );

    return SafeArea(
      child: TraslucentBackground(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
        ),
        gradient: const [
          Color(0xFFEAFFFE),
          Color(0xFFC9D9F1),
        ],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Assets.images.trophy.image(
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.gameScoreLabel(score),
                style: textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF4D5B92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
