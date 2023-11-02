import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.introBackground.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Column(
              children: [
                const Spacer(),
                Assets.images.gameLogo.image(),
                const Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    l10n.gameIntroPageHeadline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                GameElevatedButton(
                  label: l10n.gameIntroPagePlayButtonText,
                  onPressed: () => Navigator.of(context).push(GameView.route()),
                ),
                const Spacer(),
                const _Actions(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: settingsController.soundsOn,
          builder: (context, soundsOn, child) => GameIconButton(
            icon: soundsOn ? Icons.volume_up : Icons.volume_off,
            onPressed: soundsOn
                ? settingsController.toggleMuted
                : settingsController.toggleMusicOn,
          ),
        ),
        GameIconButton(
          icon: Icons.leaderboard,
          onPressed: () {},
        ),
        GameIconButton(
          onPressed: () {},
          icon: Icons.info,
        ),
        GameIconButton(
          onPressed: () {},
          icon: Icons.help,
        ),
      ],
    );
  }
}
