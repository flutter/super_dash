import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game_intro/view/game_info_dialog.dart';
import 'package:dash_run/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioButton extends StatelessWidget {
  const AudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return ValueListenableBuilder<bool>(
      valueListenable: settingsController.soundsOn,
      builder: (context, soundsOn, child) => GameIconButton(
        icon: soundsOn ? Icons.volume_up : Icons.volume_off,
        onPressed: soundsOn
            ? settingsController.toggleMuted
            : settingsController.toggleMusicOn,
      ),
    );
  }
}

class LeaderboardButton extends StatelessWidget {
  const LeaderboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GameIconButton(
      icon: Icons.leaderboard,
      onPressed: () {},
    );
  }
}

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GameIconButton(
      icon: Icons.info,
      onPressed: () => Navigator.of(context).push(GameInfoDialog.route()),
    );
  }
}

class HowToPlayButton extends StatelessWidget {
  const HowToPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GameIconButton(
      icon: Icons.help,
      onPressed: () {},
    );
  }
}
